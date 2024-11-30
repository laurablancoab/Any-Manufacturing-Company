import pandas as pd
from datetime import datetime
from sqlalchemy import create_engine

# Función para cargar CSV
def cargar_csv(ruta_archivo):
    return pd.read_csv(ruta_archivo)

# Función para convertir columnas de fecha a datetime automáticamente
def convertir_a_datetime(df):
    for columna in df.columns:
        if df[columna].dtype == 'object' and any(keyword in columna.lower() for keyword in ['fecha', 'date', 'timestamp']):
            try:
                df[columna] = pd.to_datetime(df[columna], errors='coerce')
            except Exception as e:
                print(f"Error al convertir la columna {columna} a datetime: {e}")
    return df

# Función para limpiar valores nulos
def limpiar_nulos(df):
    # Eliminar filas con cualquier valor nulo
    df = df.dropna()

    # O también, si prefieres rellenar los valores nulos, puedes usar algo como:
    # Rellenar valores nulos en columnas numéricas con la media
    for columna in df.select_dtypes(include=['float64', 'int64']).columns:
        df[columna] = df[columna].fillna(df[columna].mean())

    # Rellenar valores nulos en columnas categóricas con la moda (valor más frecuente)
    for columna in df.select_dtypes(include=['object']).columns:
        df[columna] = df[columna].fillna(df[columna].mode()[0])

    return df

# Configuración de conexión a SQL Server
SERVER = 'LAPTOP-OOBU4DR9\SQLEXPRESS'  # O la dirección de tu servidor
DATABASE = 'any_manufacturing_mb'
USERNAME = 'LAPTOP-OOBUADR9\isa_a'
PASSWORD = ''

# Cadena de conexión
conn_str = f'DRIVER={{ODBC Driver 17 for SQL Server}};SERVER={SERVER};DATABASE={DATABASE};UID={USERNAME};PWD={PASSWORD}'

# Conexión con SQLAlchemy
def connect_to_sql():
    engine = create_engine(f'mssql+pyodbc:///?odbc_connect={conn_str}')
    return engine

# Filtrar nuevos registros según la fecha de referencia
def filtrar_nuevos_registros(df, columna_fecha, fecha_referencia):
    return df[df[columna_fecha] > fecha_referencia]

# Función principal ETL
def proceso_etl():
    archivos = {
        'Sales_final_2016': {
            'ruta': r'C:\Users\isa_a\Downloads\archive (1)\SalesFINAL12312016.csv',
            'columna_clave': 'SalesDate'
        },
        'Purchase_final_2016': {
            'ruta': r'C:\Users\isa_a\Downloads\archive (1)\PurchasesFINAL12312016.csv',
            'columna_clave': 'PODate'
        },
        'Invoice_purchases_2016': {
            'ruta': r'C:\Users\isa_a\Downloads\archive (1)\InvoicePurchases12312016.csv',
            'columna_clave': 'InvoiceDate'
        },
        'Purchase_Prices_2017': {
            'ruta': r'C:\Users\isa_a\Downloads\archive (1)\2017PurchasePricesDec.csv',
            'columna_clave': None  # No aplica carga incremental basada en fechas
        },
        'Beg_inv_final_2016': {
            'ruta': r'C:\Users\isa_a\Downloads\archive (1)\BegInvFINAL12312016.csv',
            'columna_clave': 'startDate'
        },
        'End_inv_final_2016': {
            'ruta': r'C:\Users\isa_a\Downloads\archive (1)\EndInvFINAL12312016.csv',
            'columna_clave': 'endDate'
        }
    }
    
    # Fecha de referencia para carga incremental
    fecha_referencia = datetime(2016, 12, 1)

    for nombre_tabla, info in archivos.items():
        print(f"Procesando {nombre_tabla}...")
        
        # Cargar datos
        df = cargar_csv(info['ruta'])
        
        # Transformar datos (convertir fechas)
        df = convertir_a_datetime(df)
        
        # Limpiar nulos
        df = limpiar_nulos(df)
        
        # Filtrar nuevos registros si aplica
        if info['columna_clave']:
            nuevos_registros = filtrar_nuevos_registros(df, info['columna_clave'], fecha_referencia)
        else:
            nuevos_registros = df  # Si no hay columna clave, tomamos todos los datos
        
        # Guardar los datos procesados en un archivo CSV nuevo
        if not nuevos_registros.empty:
            salida = f"{nombre_tabla}_procesado.csv"
            nuevos_registros.to_csv(salida, index=False)
            print(f"Registros guardados en {salida}.")
        else:
            print(f"No se encontraron nuevos registros para {nombre_tabla}.")

# Ejecutar el proceso ETL
proceso_etl()
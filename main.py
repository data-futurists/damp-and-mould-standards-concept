import streamlit as st
import json
from pathlib import Path

# Set page title and icon
st.set_page_config(page_title="Damp & Mould Standards", page_icon="💧", layout="wide")

# Main title
st.title("Damp & Mould Standards")
st.subheader("Housing Quality Standards Evaluation Tool")
st.write("Welcome to the damp and mould data model. This model is designed to enable sufficient data capture to assess the risk of damp and mould in housing. The model is based on the HACT UK Housing Data Standards and OSCRE Industry Data Model.")

# Sidebar
with st.sidebar:
    st.header("Navigation")
    
    # Add sidebar options
    page = st.selectbox(
        "Select page to navigate to:",
        ["About", "Hazard Inspection Module", "Property Hierarchy Module", "Work Order Module"]
    )
    
    # Add a divider
    st.divider()

    # Show content based on selection
if page == "Property Hierarchy Module":
    st.header("Property Hierarchy Module")
    st.write("This module captures property information including building, block, floor, unit, and room data to establish the location hierarchy where damp and mould issues are identified. This module also encompasses data relating to energy certification and thermal transmittance data which are related to damp and mould risk.")


    # load your schema (as before)
    JSON_PATH = Path(__file__).parent / "schemas/property_component.json"
    @st.cache_data
    def load_json(path: Path):
        if not path.exists():
            st.error(f"Couldn’t find {path.name}.")
            st.stop()
        return json.loads(path.read_text())

    schema = load_json(JSON_PATH)

    # Only show Definitions section
    defs = schema.get("$defs", {})

    st.subheader("Data Dictionary")
    for def_name, def_schema in defs.items():
        with st.expander(def_name, expanded=False):
            # Top-level metadata
            st.markdown(f"**Type**: `{def_schema.get('type', '—')}`")
            desc = def_schema.get("description")
            if desc:
                st.markdown(f"**Description**: {desc}")
            st.markdown("**Properties:**")
            # List each property
            for prop_name, prop_schema in def_schema.get("properties", {}).items():
                p_type = prop_schema.get("type", "—")
                p_desc = prop_schema.get("description", "")
                st.markdown(f"- **{prop_name}** (`{p_type}`): {p_desc}")
    
    st.subheader("Creating the SQL DDL")
    st.write("The SQL DDL (Data Definition Language) statements are generated based on the JSON schema. The SQL statements define the structure of the database tables that will store the data captured by this module.")
    
    # Create SQL DDL statements and save to file
    sql_ddl = {}
    # Path to your .sql file
    sql_file = Path(__file__).parent / "scripts/property_component.sql"

    # Read the SQL code
    sql_code = sql_file.read_text()

    # Display it as a syntax-highlighted code block
    st.code(sql_code, language="sql")
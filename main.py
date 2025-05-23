import json
import re
from pathlib import Path
import streamlit as st

def main():
    st.set_page_config(page_title="Damp and Mould Standards", layout="wide")
    
    # Sidebar for navigation
    st.sidebar.title("Navigation")
    page = st.sidebar.radio(
        "Go to",
        ["Overview", "Inspection", "Property", "Work Order"]
    )
    
    # Page routing
    if page == "Overview":
        overview_page()
    elif page == "Inspection":
        inspection_page()
    elif page == "Property":
        property_page()
    elif page == "Work Order":
        work_order_page()

def overview_page():
    st.title("Overview")
    st.write("Welcome to the Damp and Mould Standards System")

def inspection_page():
    st.title("Inspection")
    st.write("This page provides an overview of the inspection component of the data model. This refers to the data model that is used to manage inspections, including their attributes and relationships.\n This component is crucial for understanding how inspections are represented in the system and how they relate to other components, such as properties and work orders.\n\n")
    st.write("The inspection component includes various attributes such as inspection ID, date, type, and status. It also defines the relationships between inspections and other entities in the system, such as properties and work orders.\n\n")

        # Create a container for the ERD
    st.subheader("Entity Relationship Diagram (ERD)")
    st.write("This diagram shows the relationships between different entities in the inspection component of the data model.")
    erd_container = st.container()
    
    with erd_container:
        # Load and display the ERD SVG
        try:
            svg_path = Path("erd/Inspection_Component.svg")  # Adjust path as needed
            with open(svg_path, "r") as f:
                svg_content = f.read()
            
            # Add custom styling to make SVG responsive
            svg_content = f'<div style="width: 100%; height: auto;">{svg_content}</div>'
            st.markdown(svg_content, unsafe_allow_html=True)
        except FileNotFoundError:
            st.error("ERD SVG file not found. Please ensure the file exists in the assets directory.")

    # Add Data Dictionary section
    st.subheader("Data Dictionary")
    st.write("Expand each entity to view its attributes and descriptions.")

    try:
        # Load JSON schema
        schema_path = Path("schemas/Inspection_component.JSON")
        with open(schema_path, 'r') as file:
            schema = json.load(file)

        # Access the "definitions" section
        definitions = schema.get("definitions", {})
        for name, definition in definitions.items():
            with st.expander(f"# {name}", expanded=False):
            # Show description if present
                desc = definition.get("description")
                if desc:
                    st.markdown(f"**Description:** {desc}")
                # Show required fields list
                required = set(definition.get("required", []))
                # List properties
                props = definition.get("properties", {})
                st.markdown("**Attributes:**")
                for prop_name, prop_schema in props.items():
                    p_type = prop_schema.get("type", "—")
                    p_format = prop_schema.get("format")
                    p_desc = prop_schema.get("description", "")
                    # build type+format string
                    type_str = f"`{p_type}`"
                    if p_format:
                        type_str = f"`{p_type}` _(format: {p_format})_"
                    # mark if required
                    req_mark = " **(required)**" if prop_name in required else ""
                    st.markdown(f"- **{prop_name}** {type_str}{req_mark}: {p_desc}")
    except FileNotFoundError:
        st.error("JSON schema file not found. Please ensure the file exists in the schemas directory.")
    except json.JSONDecodeError:
        st.error("Invalid JSON schema format. Please check the file content.")
    except KeyError:
        st.error("Error accessing definitions in JSON schema. Please ensure the schema is structured correctly.")

    # Add DDL section
    st.subheader("Data Description Language (DDL) code")

    try:
        # Load SQL file
        sql_path = Path("ddl/inspection_component.sql")
        with open(sql_path) as f:
            sql_content = f.read()
        
        # Display the SQL code
        st.code(sql_content, language='sql')

    except FileNotFoundError:
        st.error("DDL SQL file not found. Please ensure the file exists in the ddl directory.")
    


def property_page():
    st.title("Property Component")
    st.write("This page provides an overview of the property component of the data model. This refers to the data model that is used to manage properties, including their attributes and relationships.\n This component is crucial for understanding how properties are represented in the system and how they relate to other components, such as inspections and work orders.\n\n")
    st.write("The property component includes various attributes such as property ID, address, type, and status. It also defines the relationships between properties and other entities in the system, such as tenants and inspections.\n\n")
    
    # Create a container for the ERD
    st.subheader("Entity Relationship Diagram (ERD)")
    st.write("This diagram shows the relationships between different entities in the property component of the data model.")
    
    erd_container = st.container()
    
    with erd_container:
        # Load and display the ERD SVG
        try:
            svg_path = Path("erd/property-component.svg")  # Adjust path as needed
            with open(svg_path, "r") as f:
                svg_content = f.read()
            
            # Add custom styling to make SVG responsive
            svg_content = f'<div style="width: 100%; height: auto;">{svg_content}</div>'
            st.markdown(svg_content, unsafe_allow_html=True)
        except FileNotFoundError:
            st.error("ERD SVG file not found. Please ensure the file exists in the assets directory.")

    # Add Data Dictionary section
    st.subheader("Data Dictionary")
    st.write("Expand each entity to view its attributes and descriptions.")

    try:
        # Load JSON schema
        schema_path = Path("schemas/property_component.JSON")
        with open(schema_path, 'r') as file:
            schema = json.load(file)

        # Access the "definitions" section
        definitions = schema.get("definitions", {})
        for name, definition in definitions.items():
            with st.expander(f"# {name}", expanded=False):
            # Show description if present
                desc = definition.get("description")
                if desc:
                    st.markdown(f"**Description:** {desc}")
                # Show required fields list
                required = set(definition.get("required", []))
                # List properties
                props = definition.get("properties", {})
                st.markdown("**Attributes:**")
                for prop_name, prop_schema in props.items():
                    p_type = prop_schema.get("type", "—")
                    p_format = prop_schema.get("format")
                    p_desc = prop_schema.get("description", "")
                    # build type+format string
                    type_str = f"`{p_type}`"
                    if p_format:
                        type_str = f"`{p_type}` _(format: {p_format})_"
                    # mark if required
                    req_mark = " **(required)**" if prop_name in required else ""
                    st.markdown(f"- **{prop_name}** {type_str}{req_mark}: {p_desc}")
        
    except FileNotFoundError:
        st.error("JSON schema file not found. Please ensure the file exists in the schemas directory.")
    except json.JSONDecodeError:
        st.error("Invalid JSON schema format. Please check the file content.")
    except KeyError:
        st.error("Error accessing definitions in JSON schema. Please ensure the schema is structured correctly.")   
    
    # Add DDL section
    st.subheader("Data Description Language (DDL) code")

    try:
        # Load SQL file
        sql_path = Path("ddl/property_component.sql")
        with open(sql_path) as f:
            sql_content = f.read()
        
        # Display the SQL code
        st.code(sql_content, language='sql')

    except FileNotFoundError:
        st.error("DDL SQL file not found. Please ensure the file exists in the ddl directory.")

def work_order_page():
    st.title("Work Order")
    st.write("This page provides an overview of the work order component of the data model. This refers to the data model that is used to manage work orders, including their attributes and relationships.\n This component is crucial for understanding how work orders are represented in the system and how they relate to other components, such as properties and inspections.\n\n")
    st.write("The work order component includes various attributes such as work order ID, date, type, and status. It also defines the relationships between work orders and other entities in the system, such as properties and inspections.\n\n")

    erd_container = st.container()
    
    with erd_container:
        # Load and display the ERD SVG
        try:
            svg_path = Path("erd/work_order_component_erd.svg")  # Adjust path as needed
            with open(svg_path, "r") as f:
                svg_content = f.read()
            
            # Add custom styling to make SVG responsive
            svg_content = f'<div style="width: 100%; height: auto;">{svg_content}</div>'
            st.markdown(svg_content, unsafe_allow_html=True)
        except FileNotFoundError:
            st.error("ERD SVG file not found. Please ensure the file exists in the assets directory.")

    # Add Data Dictionary section
    st.subheader("Data Dictionary")
    st.write("Expand each entity to view its attributes and descriptions.")

    try:
        # Load JSON schema
        schema_path = Path("schemas/workorder_component.JSON")
        with open(schema_path, 'r') as file:
            schema = json.load(file)

        # Access the "definitions" section
        definitions = schema.get("definitions", {})
        for name, definition in definitions.items():
            with st.expander(f"# {name}", expanded=False):
            # Show description if present
                desc = definition.get("description")
                if desc:
                    st.markdown(f"**Description:** {desc}")
                # Show required fields list
                required = set(definition.get("required", []))
                # List properties
                props = definition.get("properties", {})
                st.markdown("**Attributes:**")
                for prop_name, prop_schema in props.items():
                    p_type = prop_schema.get("type", "—")
                    p_format = prop_schema.get("format")
                    p_desc = prop_schema.get("description", "")
                    # build type+format string
                    type_str = f"`{p_type}`"
                    if p_format:
                        type_str = f"`{p_type}` _(format: {p_format})_"
                    # mark if required
                    req_mark = " **(required)**" if prop_name in required else ""
                    st.markdown(f"- **{prop_name}** {type_str}{req_mark}: {p_desc}")
        
    except FileNotFoundError:
        st.error("JSON schema file not found. Please ensure the file exists in the schemas directory.")
    except json.JSONDecodeError:
        st.error("Invalid JSON schema format. Please check the file content.")
    except KeyError:
        st.error("Error accessing definitions in JSON schema. Please ensure the schema is structured correctly.")   
    
    # Add DDL section
    st.subheader("Data Description Language (DDL) code")

    try:
        # Load SQL file
        sql_path = Path("ddl/work_order_component.sql")
        with open(sql_path) as f:
            sql_content = f.read()
        
        # Display the SQL code
        st.code(sql_content, language='sql')

    except FileNotFoundError:
        st.error("DDL SQL file not found. Please ensure the file exists in the ddl directory.")
    except json.JSONDecodeError:
        st.error("Invalid JSON schema format. Please check the file content.")
    except KeyError:
        st.error("Error accessing definitions in JSON schema. Please ensure the schema is structured correctly.")   


if __name__ == "__main__":
    main()
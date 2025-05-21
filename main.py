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
    st.write("Inspection details will be shown here")

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
        schema_path = Path("schemas/property_component.json")
        with open(schema_path, 'r', encoding='utf-8') as f:
            schema = json.load(f)
        
        # Create a cleaner display of the schema structure
        if "definitions" in schema:
            for entity, details in schema["definitions"].items():
                with st.expander(f"📋 {entity}"):
                    if "description" in details:
                        st.markdown(f"**Entity Description:** {details['description']}")
                        st.markdown("---")
                    
                    st.markdown("**Attributes:**")
                    
                    # Create a more structured view using columns
                    cols = st.columns([2, 1, 3])
                    with cols[0]:
                        st.markdown("**Name**")
                    with cols[1]:
                        st.markdown("**Type**")
                    with cols[2]:
                        st.markdown("**Description**")
                    
                    # Handle both regular properties and array items
                    properties = details.get("properties", {})
                    if not properties and "items" in details:
                        properties = details["items"].get("properties", {})
                    
                    for attr, attr_details in properties.items():
                        with cols[0]:
                            st.markdown(f"`{attr}`")
                        with cols[1]:
                            type_info = attr_details.get('type', 'N/A')
                            st.markdown(f"`{type_info}`")
                        with cols[2]:
                            description = attr_details.get('description', 'No description available')
                            st.markdown(description)
                    
                    # Show required fields if specified
                    if "required" in details:
                        st.markdown("---")
                        st.markdown("**Required Fields:**")
                        st.markdown(", ".join(f"`{field}`" for field in details["required"]))

    except FileNotFoundError:
        st.error("Schema file not found. Please check if 'schemas/property_component.json' exists.")
    except json.JSONDecodeError:
        st.error("Invalid JSON schema file. Please verify the JSON format.")
    except Exception as e:
        st.error(f"An error occurred: {str(e)}")
    
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
    st.write("Work order details will be shown here")

if __name__ == "__main__":
    main()
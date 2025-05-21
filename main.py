import json
import re
from pathlib import Path
import streamlit as st

# Constants
PAGE_TITLE = "Damp & Mould Standards"
PAGE_ICON = "💧"
NAVIGATION_OPTIONS = ["About", "Hazard Inspection Module", "Property Hierarchy Module", "Work Order Module"]

def init_page_config():
    """Initialize Streamlit page configuration."""
    st.set_page_config(page_title=PAGE_TITLE, page_icon=PAGE_ICON, layout="wide")
    st.title(PAGE_TITLE)
    st.subheader("Awaab's Law")
    st.write("Welcome to the damp and mould data model. This model is designed to enable sufficient data capture to assess the risk of damp and mould in housing. The model is based on the HACT UK Housing Data Standards and OSCRE Industry Data Model.")

def create_sidebar():
    """Create and return the top navigation toolbar."""
    st.markdown("""
        <style>
            .stButton button {
                width: 100%;
                background-color: white;
                color: #000000;
                border: 1px solid #cccccc;
                border-radius: 4px;
                padding: 0.5rem;
                font-weight: 500;
            }
            .stButton button:hover {
                background-color: #f0f2f6;
                border-color: #666666;
            }
            div.row-widget.stHorizontal {
                background-color: white;
                padding: 1rem 0;
                border-bottom: 1px solid #e6e6e6;
            }
        </style>
    """, unsafe_allow_html=True)
    
    cols = st.columns(len(NAVIGATION_OPTIONS))
    for idx, option in enumerate(NAVIGATION_OPTIONS):
        with cols[idx]:
            if st.button(option):
                return option
    
    # Default to first page if no button clicked
    return NAVIGATION_OPTIONS[0]

@st.cache_data
def load_file_content(path: Path, file_type: str = 'text'):
    """Load file content with error handling."""
    if not path.exists():
        st.error(f"Couldn't find {path.name}")
        st.stop()
    
    if file_type == 'json':
        return json.loads(path.read_text())
    return path.read_text()

def display_erd(svg_path = Path("erd/property_component.svg")):
    """Display Entity Relationship Diagram."""
    svg_content = load_file_content(svg_path)
    # Add CSS for responsive SVG with centered alignment
    st.markdown("""
        <style>
            .erd-container {
                width: 100%;
                height: 80vh;
                overflow: auto;
                border: 1px solid #ddd;
                border-radius: 4px;
                margin: 20px auto;
                display: flex;
                justify-content: center;
                align-items: center;
            }
            .erd-content {
                max-width: 90%;
                margin: auto;
                text-align: center;
            }
            .erd-content svg {
                width: 100%;
                height: auto;
                max-height: 75vh;
                object-fit: contain;
            }
        </style>
        <div class="erd-container">
            <div class="erd-content">
                {svg_content}
            </div>
        </div>
    """, unsafe_allow_html=True)

def display_data_dictionary(schema: dict):
    """Display data dictionary from schema."""
    defs = schema.get("$defs", {})
    st.subheader("Data Dictionary")
    
    for def_name, def_schema in defs.items():
        with st.expander(def_name, expanded=False):
            st.markdown(f"### {def_name}")
            if desc := def_schema.get("description"):
                st.markdown(f"_{desc}_")
            st.markdown("---")
            display_entity_properties(def_schema)

def display_entity_properties(schema: dict):
    """Display entity properties in a simple list format."""
    if properties := schema.get("properties"):
        required = schema.get("required", [])
        
        for prop_name, prop_schema in properties.items():
            prop_type = prop_schema.get('type', '—')
            desc = prop_schema.get('description', '—')
            req_marker = "*" if prop_name in required else ""
            
            st.markdown(f"**{prop_name}{req_marker}**")
            st.markdown(f"- Type: `{prop_type}`")
            st.markdown(f"- {desc}")
            st.markdown("---")

def display_property_hierarchy_module():
    """Display Property Hierarchy Module content."""
    st.header("Property Hierarchy Module")
    st.write("This module captures property information including building, block, floor, unit, and room data to establish the location hierarchy where damp and mould issues are identified. This module also encompasses data relating to energy certification and thermal transmittance data which are related to damp and mould risk.")
    
    base_path = Path(__file__).parent
    sql_path = base_path / "ddl/property_component.sql"
    json_path = base_path / "schemas/property_component.json"
    svg_path = base_path / "propert-component-erd.svg"
    
    st.subheader("Entity Relationship Diagram (ERD)")
    st.write("The Entity Relationship Diagram (ERD) visually represents the structure of the database and the relationships between different entities. The diagram is generated from the SQL DDL (Data Definition Language) statements for the property component.")
    display_erd(svg_path)
    
    schema = load_file_content(json_path, 'json')
    display_data_dictionary(schema)
    
    st.subheader("Creating the SQL DDL")
    st.write("The SQL DDL (Data Definition Language) statements are generated based on the JSON schema. The SQL statements define the structure of the database tables that will store the data captured by this module.")
    sql_content = load_file_content(sql_path)
    st.code(sql_content, language="sql")
    
    st.download_button(
        label="Download SQL DDL",
        data=sql_content,
        file_name="property_hierarchy.sql",
        mime="text/plain"
    )

def main():
    """Main application entry point."""
    init_page_config()
    page = create_sidebar()
    
    if page == "Property Hierarchy Module":
        display_property_hierarchy_module()

if __name__ == "__main__":
    main()

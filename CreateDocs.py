import tkinter as tk
from tkinter import filedialog
from lxml import etree
import os
import xml.etree.ElementTree as ET

def process_xml(file_path):
    try:
        current_directory = os.path.dirname(os.path.abspath(__file__))
        xslt_path = os.path.join(current_directory, 'transform.xslt')

        # Parse the XML from the file
        tree = ET.parse(file_path)
        root = tree.getroot()

        # Create a new root for the output XML
        output_root = ET.Element("doc")

        # Copy the <assembly> tag
        assembly = root.find("assembly")
        output_root.append(assembly)

        # Prepare the <members> element for output
        members_out = ET.SubElement(output_root, "members")

        # Group members by type
        type_members = {}
        for member in root.find("members"):
            name = member.attrib["name"]
            if name.startswith("T:"):
                type_members[name[2:]] = {"type": member, "fields": []}
            #elif name.startswith("F:"):
            else:
                # Find the corresponding type this field belongs to
                for type_name in type_members:
                    if name[2:].startswith(type_name):  # Match "Ctt.Nave.LabelManager.BarcodeType"
                        type_members[type_name]["fields"].append(member)

        # Build the new structure
        for type_name, group in type_members.items():
            type_member = group["type"]
            members_out.append(type_member)
            if group["fields"]:
                fields = ET.SubElement(type_member, "fields")
                for field_member in group["fields"]:
                    fields.append(field_member)

        # Create the output file path for the temp xml file
        temp_output_file_path = os.path.splitext(file_path)[0] + "_temp.xml"

        # Check if the file exists and delete it if it does
        if os.path.exists(temp_output_file_path):
            os.remove(temp_output_file_path)
            print(f"Existing file deleted: {temp_output_file_path}")

        # Generate the output XML and write to file
        output_tree = ET.ElementTree(output_root)
        output_tree.write(temp_output_file_path, encoding="utf-8", xml_declaration=True)

        print(f"Transformed XML written to {temp_output_file_path}")

        # Parse the XML and XSLT files
        xml_tree = etree.parse(temp_output_file_path)
        xslt_tree = etree.parse(xslt_path)

        # Create an XSLT transformer
        transform = etree.XSLT(xslt_tree)

        # Apply the transformation
        transformed_tree = transform(xml_tree)

        # Create the output file path with the same name as the XML but with .html extension
        output_file_path = os.path.splitext(file_path)[0] + ".html"

        # Check if the file exists and delete it if it does
        if os.path.exists(output_file_path):
            os.remove(output_file_path)
            print(f"Existing file deleted: {output_file_path}")

        # Save the result to the file
        with open(output_file_path, "wb") as output_file:
            output_file.write(etree.tostring(transformed_tree, pretty_print=True, encoding="utf-8"))

        try:
            os.remove(temp_output_file_path)
            print(f"{temp_output_file_path} has been deleted successfully.")
        except FileNotFoundError:
            print(f"{temp_output_file_path} does not exist.")
        except PermissionError:
            print(f"Permission denied to delete {temp_output_file_path}.")
        except Exception as e:
            print(f"An error occurred while deleting {temp_output_file_path}: {e}")

        print(f"Transformation saved to: {output_file_path}")

    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    root = tk.Tk()
    root.withdraw()  # Hide the main window
    file_path = filedialog.askopenfilename(title="Select an XML file", filetypes=[("XML Files", "*.xml")])
    if file_path:
        process_xml(file_path)
    else:
        print("No file selected.")

import subprocess
import logging
import xml.etree.ElementTree as ET

# HIGH SEVERITY: Remote Code Execution via unsafe YAML loading
import yaml

def load_config(config_data):
    """
    HIGH SEVERITY: CKV_YAML_LOAD
    Using yaml.load() without SafeLoader allows arbitrary code execution
    Attacker can execute arbitrary Python code by crafting malicious YAML
    """
    config = yaml.load(config_data, Loader=yaml.Loader)
    return config


# MEDIUM SEVERITY: XML External Entity (XXE) vulnerability
def parse_user_xml(xml_string):
    """
    MEDIUM SEVERITY: CKV_XXE
    Parsing XML without disabling external entities
    Can lead to information disclosure, SSRF, or DoS
    """
    parser = ET.XMLParser()
    tree = ET.fromstring(xml_string, parser=parser)
    return tree


# LOW SEVERITY: Debug mode enabled in production
DEBUG = True  # CKV_DEBUG_ENABLED

def get_user_profile(user_id):
    """
    LOW SEVERITY: Verbose error messages
    Exposing stack traces and internal details in production
    """
    try:
        # Some database operation
        result = fetch_from_db(user_id)
        return result
    except Exception as e:
        if DEBUG:
            # CKV_INFORMATION_DISCLOSURE: Exposing internal error details
            logging.error(f"Database error: {e.__class__.__name__}: {str(e)}")
            logging.error(f"Query details: SELECT * FROM users WHERE id={user_id}")
        raise


def fetch_from_db(user_id):
    pass

import oc
import types

def test_json():
    assert oc.parse_json('{"foo": "bar"}') == dict(foo='bar')
    assert oc.parse_json('["hello", "world"]') == ['hello', 'world']

def test_calling_a_command_and_getting_stdout():
    assert oc.stdout_of(['echo', 'hi']) == 'hi\n'

def test_integration_through_class():
    assert oc.Client().cabbages() == dict()

def test_integration_through_global_function():
    assert oc.cabbages() == dict()

def test_getting_username_and_password_from_a_shell_script():
    assert oc.get_credentials_exported_by("""
    export OC2RTA_USERNAME=alice
    export OC2RTA_PASSWORD=t0ps3cret
    """) == ['alice', 't0ps3cret']

def test_getting_password_with_weird_characters():
    assert oc.get_credentials_exported_by("""
    export OC2RTA_USERNAME=alice
    export OC2RTA_PASSWORD=':!@#$a%^&*(b)"'
    """) == ['alice', ':!@#$a%^&*(b)"']

def test_getting_password_with_single_quote():
    assert oc.get_credentials_exported_by("""
    export OC2RTA_USERNAME=alice
    export OC2RTA_PASSWORD="'"
    """) == ['alice', "'"]

def test_getting_password_with_newline():
    assert oc.get_credentials_exported_by("""
    export OC2RTA_USERNAME=alice
    export OC2RTA_PASSWORD="
"
    """) == ['alice', '\n']

def test_getting_password_with_dashes():
    assert oc.get_credentials_exported_by("""
    export OC2RTA_USERNAME=alice
    export OC2RTA_PASSWORD="--not-a-flag"
    """) == ['alice', '--not-a-flag']

def test_getting_username_and_password_from_a_script_that_echoes_things():
    assert oc.get_credentials_exported_by("""
    echo "mess you up"
    export OC2RTA_USERNAME=alice
    export OC2RTA_PASSWORD=password
    """) == ['alice', 'password']

def test_getting_username_and_password_from_a_script_with_no_newline_at_the_end():
    assert oc.get_credentials_exported_by("""
    export OC2RTA_USERNAME=alice
    export OC2RTA_PASSWORD=password""") == ['alice', 'password']

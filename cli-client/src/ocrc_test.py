import ocrc

def test_getting_username_and_password_from_a_shell_script():
    assert ocrc.get_credentials_exported_by("""
    export OC2RTA_USERNAME=alice
    export OC2RTA_PASSWORD=t0ps3cret
    """) == ['alice', 't0ps3cret']

def test_getting_password_with_weird_characters():
    assert ocrc.get_credentials_exported_by("""
    export OC2RTA_USERNAME=alice
    export OC2RTA_PASSWORD=':!@#$a%^&*(b)"'
    """) == ['alice', ':!@#$a%^&*(b)"']

def test_getting_password_with_single_quote():
    assert ocrc.get_credentials_exported_by("""
    export OC2RTA_USERNAME=alice
    export OC2RTA_PASSWORD="'"
    """) == ['alice', "'"]

def test_getting_password_with_newline():
    assert ocrc.get_credentials_exported_by("""
    export OC2RTA_USERNAME=alice
    export OC2RTA_PASSWORD="
"
    """) == ['alice', '\n']

def test_getting_password_with_dashes():
    assert ocrc.get_credentials_exported_by("""
    export OC2RTA_USERNAME=alice
    export OC2RTA_PASSWORD="--not-a-flag"
    """) == ['alice', '--not-a-flag']

def test_getting_username_and_password_from_a_script_that_echoes_things():
    assert ocrc.get_credentials_exported_by("""
    echo "mess you up"
    export OC2RTA_USERNAME=alice
    export OC2RTA_PASSWORD=password
    """) == ['alice', 'password']

def test_getting_username_and_password_from_a_script_with_no_newline_at_the_end():
    assert ocrc.get_credentials_exported_by("""
    export OC2RTA_USERNAME=alice
    export OC2RTA_PASSWORD=password""") == ['alice', 'password']

def test_failing_to_get_username_and_password_when_script_doesnt_define_them():
    assert ocrc.get_credentials_exported_by('') == ['', '']

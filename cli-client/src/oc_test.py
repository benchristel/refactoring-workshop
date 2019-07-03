import oc
import types

def test_json():
    assert oc.parse_json('{"foo": "bar"}') == dict(foo='bar')
    assert oc.parse_json('["hello", "world"]') == ['hello', 'world']

def test_calling_a_command_and_getting_stdout():
    assert oc.stdout_of(['echo', 'hi']) == 'hi\n'

def test_integration():
    assert (oc.Client(ocrc_path="fakes/ocrc").cabbages()
        == dict(args=['cabbages', '--username', 'elias', '--password', '`a$1""!`']))

def test_integration_through_global_function():
    assert oc.cabbages()['args'][0] == 'cabbages'

def test_integration_when_no_credentials():
    assert (oc.Client(ocrc_path="i-do-not-exist").cabbages()
        == dict(args=['cabbages']))

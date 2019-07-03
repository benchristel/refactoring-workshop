import oc
import types

def test_json():
    assert oc.parse_json('{"foo": "bar"}') == dict(foo='bar')
    assert oc.parse_json('["hello", "world"]') == ['hello', 'world']

def test_calling_a_command_and_getting_stdout():
    assert oc.stdout_of(['echo', 'hi']) == 'hi\n'

def test_credentials_passed_as_args():
    assert (oc.Client(username="bob", password="foo").creds().oc_args()
        == ['--username', 'bob', '--password', 'foo'])

def test_credentials_parsed_from_file():
    assert (oc.Client(ocrc_path="fakes/ocrc").creds().oc_args()
        == ['--username', 'elias', '--password', '`a$1""!`'])

def test_no_credentials():
    assert oc.Client().creds().oc_args() == []

def test_integration():
    assert (oc.Client(ocrc_path="fakes/ocrc").cabbages()
        == dict(args=['cabbages', '--username', 'elias', '--password', '`a$1""!`']))

def test_integration_through_global_function():
    assert oc.cabbages()['args'][0] == 'cabbages'

def test_integration_when_no_credentials():
    assert (oc.Client(ocrc_path="i-do-not-exist").cabbages()
        == dict(args=['cabbages']))

def test_integration_when_credentials_passed_as_args():
    assert (oc.Client(username="a", password="b").cabbages()
        == dict(args=['cabbages', '--username', 'a', '--password', 'b']))

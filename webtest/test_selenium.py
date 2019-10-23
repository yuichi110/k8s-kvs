import sys, time, datetime, requests
from selenium import webdriver
from selenium.webdriver.common.desired_capabilities import DesiredCapabilities
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.options import Options
from selenium.common.exceptions import UnexpectedAlertPresentException

HUBURL = 'http://selenium_hub:4444/wd/hub'
WEBURL = 'http://web/'
APIURL = 'http://web/api/v1'

##################
### GET BUTTON ###
##################

# print(driver.find_element_by_id('table').get_attribute('innerHTML'))

def test_get_nokey():
  clean_and_add_keys()
  (driver, elem_key, elem_value, elem_get, elem_post, elem_put, elem_delete) = get_driver_elements()
  elem_get.click()
  take_screenshot(driver, sys._getframe().f_code.co_name)
  driver.quit()
  assert True

def test_get_key_exist():
  clean_and_add_keys()
  (driver, elem_key, elem_value, elem_get, elem_post, elem_put, elem_delete) = get_driver_elements()
  elem_key.send_keys('apple')
  elem_get.click()
  take_screenshot(driver, sys._getframe().f_code.co_name)
  driver.quit()
  assert True

def test_get_key_notexist():
  clean_and_add_keys()
  (driver, elem_key, elem_value, elem_get, elem_post, elem_put, elem_delete) = get_driver_elements()
  elem_key.send_keys('grape')
  elem_get.click()
  take_screenshot(driver, sys._getframe().f_code.co_name)
  driver.quit()
  assert True


###################
### POST BUTTON ###
###################


#print(driver.find_element_by_id('table').get_attribute('innerHTML'))

###############
### Utility ###
###############

def get_driver_elements():
  options = Options()
  options.add_argument('--headless')
  driver = webdriver.Remote(
            command_executor=HUBURL,
            desired_capabilities=DesiredCapabilities.CHROME)
  driver.get(WEBURL)

  elem_key = driver.find_element_by_id('key')
  elem_value = driver.find_element_by_id('value')
  elem_get = driver.find_element_by_id('get-button')
  elem_post = driver.find_element_by_id('post-button')
  elem_put = driver.find_element_by_id('put-button')
  elem_delete = driver.find_element_by_id('delete-button')

  return (driver, elem_key, elem_value, elem_get, elem_post, elem_put, elem_delete)

def take_screenshot(driver, title):
  today = datetime.datetime.today()
  timestamp = today.strftime("%Y%m%d%H%M%S")
  driver.save_screenshot(f'images/{timestamp}-{title}.png')

def clean():
  r = requests.get(f'{APIURL}/keys/')
  for key in r.json():
    requests.delete(f'{APIURL}/keys/{key}')

  num_keys = len(requests.get(f'{APIURL}/keys/').json())
  assert 0 == num_keys

def clean_and_add_keys():
  clean()
  r = requests.put(f'{APIURL}/keys/apple', data='red')
  assert r.status_code == 200
  r = requests.put(f'{APIURL}/keys/banana', data='yellow')
  assert r.status_code == 200
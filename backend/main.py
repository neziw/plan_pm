from mapper import Mapper
from scrapper import Scrapper

mapper = Mapper()
mapper.run(minID=300, maxID=400, output="./output/flows.json")
del mapper


Scrapper().run(max_workers=5)
del Scrapper
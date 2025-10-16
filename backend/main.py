from mapper import Mapper
from scrapper import Scrapper
from parser import Parser

mapper = Mapper()
mapper.run(minID=300, maxID=400, output="./output/flows.json")

Scrapper().run(max_workers=5)

Parser().run()
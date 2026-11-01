"""Build the small public directory. Reads production metadata; writes only this repo."""
import json,os,urllib.request,urllib.parse
from pathlib import Path
from datetime import datetime
ROOT=Path(__file__).resolve().parents[1]
# Repository layout: scripts/refresh-directory.py, data/supported-games-config.json.
CONFIG=ROOT/'data/supported-games-config.json'
OUTPUT=ROOT/'data/supported-games.json'
API='https://api.github.com/repos/MUshihara/Serenity-hub/'
def get(path):
    headers={'Accept':'application/vnd.github+json','User-Agent':'SerenityDirectory'}
    if os.environ.get('GH_TOKEN'):headers['Authorization']='Bearer '+os.environ['GH_TOKEN']
    with urllib.request.urlopen(urllib.request.Request(API+path,headers=headers),timeout=30)as response:
        return json.load(response)
def build(config,revision,fetch):
    games=[]
    for item in config['games']:
        row={k:item[k]for k in ('name','universeId','placeId','status')}
        path=item.get('runtimePath')
        history=fetch('commits?'+urllib.parse.urlencode({'sha':revision,'path':path,'per_page':1}))if path else []
        row['updatedAt']=int(datetime.fromisoformat(history[0]['commit']['committer']['date'].replace('Z','+00:00')).timestamp())if history else 0
        games.append(row)
    return {'schemaVersion':1,'sourceRevision':revision,'games':games}
def main():
    config=json.loads(CONFIG.read_text());revision=get('commits/main')['sha']
    previous=json.loads(OUTPUT.read_text())if OUTPUT.exists()else {}
    # A configuration edit also rebuilds via the workflow, even if production did not change.
    result=build(config,revision,get)
    encoded=json.dumps(result,indent=2,ensure_ascii=False)+'\n'
    if not OUTPUT.exists()or OUTPUT.read_text()!=encoded:OUTPUT.write_text(encoded)
if __name__=='__main__':main()

from flask import Flask
from flask import request
import pandas as pd
import json
import numpy as np
from sklearn.decomposition import PCA
import sys
import process_input_data
app = Flask(__name__)

@app.route('/fetchIndividualFacialRawData', methods=["POST"])
def fetchIndividualFacialRawData():
    id = request.json['id']
    if id:
        individualFacialRawData = process_input_data.read_rawFacialDf(sys.argv[1], id)
    else:
        individualFacialRawData = process_input_data.read_rawFacialDf(sys.argv[1], inputData['Filename'][0])
    if individualFacialRawData.empty:
        return {}
    return individualFacialRawData.fillna(0).to_json(orient="records")


@app.route('/fetchIndividualMovementRawData', methods=["POST"])
def fetchIndividualMovementRawData():
    id = request.json['id']
    if id:
        individualMovementRawData  = process_input_data.read_rawMovementDf(sys.argv[1], id)
    else:
        individualMovementRawData  = process_input_data.read_rawMovementDf(sys.argv[1], inputData['Filename'][0])
    if individualMovementRawData.empty:
        return {}
    return individualMovementRawData.fillna(0).to_json(orient="records")

@app.route('/fetchIndividualAcousticRawData', methods=["POST"])
def fetchIndividualAcousticRawData():
    id = request.json['id']
    if id:
        individualAcousticRawData = process_input_data.read_rawAcousticDf(sys.argv[1], id)
    else:
        individualAcousticRawData = process_input_data.read_rawAcousticDf(sys.argv[1], inputData['Filename'][0])
    if individualAcousticRawData.empty:
        return {}
    return individualAcousticRawData.fillna(0).to_json(orient="records")

@app.route('/fetchIndividualDerivedData', methods=["POST"])
def fetchIndividualDerivedData():
    if len(list(inputData.columns)) <2:
        return {}
    id = request.json['id']
    if id:
        res = inputData.loc[inputData['Filename'] == id, ~inputData.columns.isin(['Filename'])]
    else:  
        res =  inputData.iloc[:1, :].loc[:, ~inputData.columns.isin(['Filename'])]
    return res.fillna(0).to_json(orient="records")



@app.route('/fetchIndividualFacialTimelineData', methods=["POST"])
def fetchIndividualFacialTimelineData():
    id = request.json['id']
    timepoints = 20
    if id:
        dfFace = process_input_data.read_rawFacialDf(sys.argv[1], id)
        dfMovement = process_input_data.read_rawMovementDf(sys.argv[1], id)
        
    else:
        dfFace = process_input_data.read_rawFacialDf(sys.argv[1], inputData['Filename'][0])
        dfMovement = process_input_data.read_rawMovementDf(sys.argv[1], inputData['Filename'][0])
    if dfFace.empty:
        return {}
    dfFace=dfFace.fillna(0)
    attrOfInterest= ["fac_angintsoft", "fac_feaintsoft", "fac_disintsoft", "fac_sadintsoft",
                        "fac_conintsoft", "fac_surintsoft", "fac_hapintsoft", 
                        "fac_AU01int", "fac_AU02int", "fac_AU04int", "fac_AU05int", "fac_AU06int", 
                        "fac_AU07int", "fac_AU09int", "fac_AU10int", "fac_AU12int","fac_AU14int", 
                        "fac_AU15int", "fac_AU17int", "fac_AU20int", "fac_AU23int", "fac_AU25int", 
                        "fac_AU26int", "fac_asymmaskcom", "fac_asymmaskeye", "fac_asymmaskeyebrow",
                        "fac_asymmaskmouth", "fac_paiintsoft", "fac_comintsoft", 
                        "fac_comlowintsoft", "fac_comuppintsoft"]
    timelineObject = {}
    for a in attrOfInterest:
        timelineObject[a] = []
    seg = len(dfFace)//19
    reminder = len(dfFace)%19

    for t in range(0,timepoints):
            for k in attrOfInterest:
                if t <= reminder:
                    timelineObject[k].append(sum(list(dfFace[t*(seg + 1):(t+1)*(seg+1)][k]))/(seg+1))
                else:
                    timelineObject[k].append(sum(list(dfFace[t*seg:(t+1)*seg][k]))/seg)
    if dfMovement.empty:
            return timelineObject
    dfMovement=dfMovement.fillna(0)
    movementAttr = ["mov_hposepitch", "mov_hposeyaw", "mov_hposeroll"]
    for a in movementAttr:
        timelineObject[a] = []
    seg = len(dfMovement)//20
    reminder = len(dfMovement)%20
    for t in range(0,timepoints):
            for k in movementAttr:
                if t <= reminder:
                    timelineObject[k].append(sum(list(dfMovement[t*(seg + 1):(t+1)*(seg+1)][k]))/(seg+1))
                else:
                    timelineObject[k].append(sum(list(dfMovement[t*seg:(t+1)*seg][k]))/seg)

    return timelineObject


@app.route('/getRawAttributesAndIds')
def getRawAttributesAndIds():
    result = {}
    if not individualFacialRawData.empty:
        result['facial'] = [x for x in list(individualFacialRawData.columns) if x not in ["frame"]]
    else:
        result['facial'] =[]
    if not individualAcousticRawData.empty:
        result['acoustic'] = [x for x in list(individualAcousticRawData.columns) if x not in ["Frames"]]
    else:
        result['acoustic'] = []
    if not individualMovementRawData.empty:
        result['movement'] = [x for x in list(individualMovementRawData.columns) if x not in ["Frames"]]
    else:
        result['movement'] = []
    if len(rawDataArgs) > 0:
        result['ids'] = rawDataArgs['ids']
    else:
        result['ids'] = []
    return result

def individualCorrMatrixData(id):
    if id:
        individualFacialRawData = process_input_data.read_rawFacialDf(sys.argv[1], id)
        individualMovementRawData  = process_input_data.read_rawMovementDf(sys.argv[1], id)
        individualAcousticRawData = process_input_data.read_rawAcousticDf(sys.argv[1], id)
    else:
        individualFacialRawData = process_input_data.read_rawFacialDf(sys.argv[1], inputData['Filename'][0])
        individualMovementRawData  = process_input_data.read_rawMovementDf(sys.argv[1], inputData['Filename'][0])
        individualAcousticRawData = process_input_data.read_rawAcousticDf(sys.argv[1], inputData['Filename'][0])
    f = individualFacialRawData
    m = individualMovementRawData
    a = individualAcousticRawData
    if f.empty:
        f = pd.DataFrame()
    if m.empty:
        m = pd.DataFrame()
    if a.empty:
        a = pd.DataFrame()
    min_len =  min(min(len(a), len(m)), len(f))
    if min_len == len(f):
        all_df = f.copy()
        if len(f) == len(m):
            for x in m.columns:
                if x not in ['Frames', 'frame']:
                    all_df[x] = m[x]
        else:
            seg = int(len(m)/(max(len(f),1)))
            reminder = len(m)%(max(len(f),1))
            for i, row in all_df.iterrows():
                for x in m.columns:
                    if x not in ['Frames', 'frame']:
                        if i <reminder:
                            all_df.loc[i,x] = sum(list(m[i*(seg + 1):(i+1)*(seg+1)][x]))/(seg+1)
                        else:
                            all_df.loc[i,x] = sum(list(m[i*seg:(i+1)*seg][x]))/seg
        if len(a) > len(f):
            seg = int(len(a)/(max(len(f),1)))
            reminder = len(a)%(max(len(f),1)) 
            for i, row in all_df.iterrows():
                for x in a.columns:
                    if x not in ['Frames', 'frame']:
                        if i <reminder:
                            all_df.loc[i,x] = sum(list(a[i*(seg + 1):(i+1)*(seg+1)][x]))/(seg+1)
                        else:
                            all_df.loc[i,x] = sum(list(a[i*seg:(i+1)*seg][x]))/seg
        else:
            for x in a.columns:
                if x not in ['Frames', 'frame']:
                    all_df[x] = a[x]    
    elif len(m) == min_len:
        all_df = m.copy()
        seg = int(len(f)/(max(len(m),1)))
        reminder = len(f)%(max(len(m),1))  
        for i, row in all_df.iterrows():
            for x in f.columns:
                if x not in ['Frames', 'frame']:
                    if i <reminder:
                        all_df.loc[i,x] = sum(list(f[i*(seg + 1):(i+1)*(seg+1)][x]))/(seg+1)
                    else:
                        all_df.loc[i,x] = sum(list(f[i*seg:(i+1)*seg][x]))/seg
        if len(a) > len(m):
            seg = int(len(a)/(max(len(m),1)))
            reminder = len(a)%(max(len(m),1))   
            for i, row in all_df.iterrows():
                for x in a.columns:
                    if x not in ['Frames', 'frame']:
                        if i <reminder:
                            all_df.loc[i,x] = sum(list(a[i*(seg + 1):(i+1)*(seg+1)][x]))/(seg+1)
                        else:
                            all_df.loc[i,x] = sum(list(a[i*seg:(i+1)*seg][x]))/seg
        else:
            for x in a.columns:
                if x not in ['Frames', 'frame']:
                    all_df[x] = a[x]
    else:
        all_df = a.copy()
        seg = int(len(f)/(max(len(a),1)))
        reminder = len(f)%(max(len(a),1))
        for i, row in all_df.iterrows():
            for x in f.columns:
                if x not in ['Frames', 'frame']:
                    if i <reminder:
                        all_df.loc[i,x] = sum(list(f[i*(seg + 1):(i+1)*(seg+1)][x]))/(seg+1)
                    else:
                        all_df.loc[i,x] = sum(list(f[i*seg:(i+1)*seg][x]))/seg
        seg = int(len(m)/(max(len(a),1)))
        reminder = len(m)%(max(len(a),1))
        for i, row in all_df.iterrows():
            for x in m.columns:
                if x not in ['Frames', 'frame']:
                    if i <reminder:
                        all_df.loc[i,x] = sum(list(m[i*(seg + 1):(i+1)*(seg+1)][x]))/(seg+1)
                    else:
                        all_df.loc[i,x] = sum(list(m[i*seg:(i+1)*seg][x]))/seg

    return all_df.fillna(0)


@app.route("/performPCA")
def performPCA(PCAargs=[]):
    if len(list(inputData.columns)) <2:
        return {}
    pca = PCA()
    if len(PCAargs) == 0:
        X = pd.DataFrame(columns = [x for x in list(inputData.columns) if x not in ['Filename']])
        X = inputData.loc[:, ~inputData.columns.isin(['Filename'])]

    else:
        X = pd.DataFrame(columns = [x for x in PCAargs ])
        X = inputData.loc[:, inputData.columns.isin(PCAargs)]

    X = X.fillna(0)
    x_pca = pca.fit_transform(X)
    x_pca = pd.DataFrame(x_pca)
    x_pca = x_pca.iloc[:, list(range(2))]
    x_pca.columns = ['PC1', "PC2"]
    pc1 = x_pca["PC1"].to_numpy()
    pc2 = x_pca["PC2"].to_numpy()
    pc1 = list((pc1 -pc1.mean())/np.std(pc1))
    pc2 = list((pc2 -pc2.mean())/np.std(pc2))
    pca_results =[[pc1[i], pc2[i]] for i in range(0, len(pc1))]

    return dict(zip(inputData['Filename'], pca_results))


@app.route('/updatePCA', methods=["POST"])
def updatePCA():
    PCAargs = request.json['PCA_args']
    return performPCA(PCAargs)


@app.route('/defaultDistribution', methods=["POST"])
def defaultDistribution():
    args = request.json['distributionArgs']
    return {"data":updateDistribution(args)}


@app.route('/updateDistribution', methods=["POST"])
def updateDistribution(attr=[]):
    if len(list(inputData.columns)) <2:
        return {}
    if len(attr) !=0:
        distributionArgs = attr
    else:
        distributionArgs = request.json['distributionArgs']
    if len(distributionArgs) == 0:
        df = pd.DataFrame(columns = [x for x in list(inputData.columns) if x not in ['Filename']])
        df = inputData.loc[:, ~inputData.columns.isin(['Filename'])]

    else:
        cols = ['Filename']+ distributionArgs
        df = pd.DataFrame(columns = [c for c in list(cols )])
        df = inputData.loc[:, inputData.columns.isin(cols)]
    df = df.fillna(0)
    if len(distributionArgs) ==0:
        return {}
    result = {}
    for i, row in df.iterrows():
        result[row['Filename']]={}
        result[row['Filename']]['id'] = row['Filename']
        for attr in distributionArgs:
            result[row['Filename']][attr] = row[attr]

    return result


@app.route('/defaultCorrMatrix', methods=["POST"])
def defaultCorrMatrix():
    corrMatrixArgs = request.json['corrMatrix_args']
    individual_corr = request.json['individual']
    id= request.json['id']
    return updateCorrMatrix(corrMatrixArgs, individual_corr, id)


@app.route('/updateCorrMatrix', methods=["POST"])
def updateCorrMatrix(attr=[], individual = False, id=None):
    if len(attr) !=0:
        corrMatrixArgs = attr
    else:
        corrMatrixArgs = request.json['corrMatrix_args']
        individual = request.json['individual']
    if len(corrMatrixArgs) < 2:
        return {}
    if len(corrMatrixArgs) > 24:
        return{}

    df = pd.DataFrame(columns = [c for c in corrMatrixArgs])
    if individual:
        if not id:
            id = request.json['id']
        d = individualCorrMatrixData(id)
        df = d.loc[:, d.columns.isin(corrMatrixArgs)]
    else:
        df = inputData.loc[:, inputData.columns.isin(corrMatrixArgs)]

    corrMatrix = df.corr(method="spearman").fillna(0)
    return corrMatrix.to_dict()



@app.route("/getDerivedAttributes")
def getDerivedAttributes():
    if not len(rawDataArgs):
        return {"facial": [], "acoustic":[], "movement":[], "speech": [], "ids": []}

    res={"facial": rawDataArgs['facialAttr'], "acoustic": rawDataArgs['acousticAttr'], "movement": rawDataArgs['movementAttr'], 
    "speech": rawDataArgs["speechAttr"], "ids": rawDataArgs['ids']}
    return res

@app.route("/getMetadata")
def getMetadata():
    if not len(metadata):
        return {}

    return metadata

def load():
    global rawDataArgs, metadata
    rawDataArgs = process_input_data.read_derivedAttr(sys.argv[1])
    if len(sys.argv) >2:
        metadata = process_input_data.read_medatada(sys.argv[1], sys.argv[2])
    else:
        metadata=[]
    global inputData
    inputData = process_input_data.read_derivedDf(sys.argv[1])
    if len(inputData):
        inputData['Filename'] = inputData['Filename'].apply(lambda x: x.split('/')[1].replace(".mp4", ""))
    else:
        inputData['Filename'] = [""]
    global individualFacialRawData, individualDerivedData, individualAcousticRawData, individualMovementRawData
    individualFacialRawData = process_input_data.read_rawFacialDf(sys.argv[1], inputData['Filename'][0])
    individualMovementRawData  = process_input_data.read_rawMovementDf(sys.argv[1], inputData['Filename'][0])
    individualAcousticRawData = process_input_data.read_rawAcousticDf(sys.argv[1], inputData['Filename'][0])


if __name__=="__main__":
    # from waitress import serve

    load()
    # serve(app, host='127.0.0.1', port=5000)
    app.run(debug=True)
    # app.run(debug=False)
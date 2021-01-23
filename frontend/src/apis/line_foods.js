import axios from 'axios';
import { lineFoods, lineFoodsReplace } from '../urls/index'

//仮注文の作成
export const postLineFoods = async(params) => {
  return await axios.post(lineFoods,
    {
      food_id: params.foodId,
      count: params.count,
    }
  )
  .then(res => {
    return res.data
  })
  .catch((e) => { throw e; })
};

//仮注文の上書き
export const replaceLineFoods = async(params) => {
  return await axios.put(lineFoodsReplace,
    {
      food_id: params.foodId,
      count: params.count,
    }
  )
  .then(res => {
    return res.data
  })
  .catch((e) => { throw e; })
};

export const fetchLineFoods = async() => {
  return await axios.get(lineFoods)
  .then(res => {
    return res.data
  })
  //throwで例外をあげるとcatchに入る
  .catch((e) => { throw e; })
};
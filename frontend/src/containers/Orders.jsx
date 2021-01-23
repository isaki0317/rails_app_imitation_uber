import React, { Fragment, useEffect } from 'react';
//url
import { fetchLineFoods } from '../apis/line_foods';

export const Orders = () => {

  useEffect(() => {
    fetchLineFoods()
      .then((data) =>
        console.log(data)
      )
      //throw eを受け取る
      .catch((e) => console.error(e));
  }, []);

  return (
    <Fragment>
      注文画面
    </Fragment>
  )
}
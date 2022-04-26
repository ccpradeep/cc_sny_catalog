import { createSlice, PayloadAction } from "@reduxjs/toolkit"
import api from "lib/api"
import { RootState } from "lib/store"

// Define a type for the slice state
interface PagesState {
  pages: []
  pageEdit: null
}

// Define the initial state using that type
const initialState: PagesState = {
  pages: [],
  pageEdit: null,
}

export const pagesSlice = createSlice({
  name: "pages",
  // `createSlice` will infer the state type from the `initialState` argument
  initialState,
  reducers: {
    // Use the PayloadAction type to declare the contents of `action.payload`
    incrementByAmount: (state, action: PayloadAction<number>) => {
      state.value += action.payload
    },
    receivePages: (state, { payload }: PayloadAction<any>) => {
      state.pages = payload
    },
    receivePage: (state, { payload }: PayloadAction<any>) => {
      state.pageEdit = payload
    },
  },
})

export const { receivePages, receivePage } = pagesSlice.actions

// Other code such as selectors can use the imported `RootState` type
export const selectPages = (state: RootState) => state.pages

export default pagesSlice.reducer

export function fetchPages() {
  return (dispatch, getState) => {
    return api.pages
      .list()
      .then(({ status, json }) => {
        dispatch(receivePages(json))
      })
      .catch(error => {})
  }
}

export function fetchPage(id) {
  return (dispatch, getState) => {
    return api.pages
      .retrieve(id)
      .then(({ status, json }) => {
        dispatch(receivePage(json))
      })
      .catch(error => {})
  }
}

export function createPage(page) {
  return (dispatch, getState) => {
    return api.pages
      .create(page)
      .then(({ status, json }) => {
        dispatch(fetchPages())
      })
      .catch(error => {})
  }
}

export function updatePage(page) {
  return (dispatch, getState) => {
    return api.pages
      .update(page.id, page)
      .then(({ status, json }) => {
        dispatch(receivePage(json))
      })
      .catch(error => {})
  }
}

export function deletePage(pageId) {
  return (dispatch, getState) => {
    return api.pages
      .delete(pageId)
      .then(({ status, json }) => {
        dispatch(fetchPages())
      })
      .catch(error => {})
  }
}

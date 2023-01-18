object dmSlicenDice: TdmSlicenDice
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 511
  Width = 1124
  object conSlicenDice: TADOConnection
    ConnectionString = 
      'Provider=Microsoft.Jet.OLEDB.4.0;User ID=Admin;Data Source=Slice' +
      'nDiceDB.mdb;Mode=ReadWrite;Persist Security Info=False;'
    LoginPrompt = False
    Mode = cmReadWrite
    Provider = 'Microsoft.Jet.OLEDB.4.0'
    Left = 72
    Top = 88
  end
  object tblIngredient: TADOTable
    Connection = conSlicenDice
    CursorType = ctStatic
    TableName = 'tblIngredient'
    Left = 216
    Top = 88
  end
  object dsrIngredient: TDataSource
    DataSet = tblIngredient
    Left = 216
    Top = 152
  end
  object tblRecipe: TADOTable
    Connection = conSlicenDice
    CursorType = ctStatic
    TableName = 'tblRecipe'
    Left = 304
    Top = 88
  end
  object dsrRecipe: TDataSource
    DataSet = tblRecipe
    Left = 304
    Top = 152
  end
  object tblRecipeIngredientNeed: TADOTable
    Connection = conSlicenDice
    CursorType = ctStatic
    TableName = 'tblRecipeIngredientNeed'
    Left = 400
    Top = 88
  end
  object dsrRecipeIngredientNeed: TDataSource
    DataSet = tblRecipeIngredientNeed
    Left = 400
    Top = 152
  end
  object tblTrack: TADOTable
    Connection = conSlicenDice
    CursorType = ctStatic
    TableName = 'tblTrack'
    Left = 488
    Top = 88
  end
  object dsrTrack: TDataSource
    DataSet = tblTrack
    Left = 488
    Top = 152
  end
  object dsrIngredientsNeeded: TDataSource
    DataSet = qryIngredientsNeeded
    Left = 680
    Top = 152
  end
  object qryIngredientsNeeded: TADOQuery
    Connection = conSlicenDice
    Parameters = <>
    SQL.Strings = (
      'SELECT * FROM tblRecipe')
    Left = 680
    Top = 88
  end
  object qryAnalytics: TADOQuery
    Connection = conSlicenDice
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT * FROM tblRecipe')
    Left = 768
    Top = 88
  end
  object dsrAnalytics: TDataSource
    DataSet = qryAnalytics
    Left = 768
    Top = 152
  end
  object tblRecipePreview: TADOTable
    Connection = conSlicenDice
    CursorType = ctStatic
    TableName = 'tblRecipe'
    Left = 304
    Top = 216
  end
  object dsrRecipePreview: TDataSource
    DataSet = tblRecipePreview
    Left = 304
    Top = 280
  end
  object dsrRecipeSearch: TDataSource
    DataSet = qryRecipeSearch
    Left = 680
    Top = 280
  end
  object qryRecipeSearch: TADOQuery
    Connection = conSlicenDice
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT * FROM tblRecipe')
    Left = 680
    Top = 216
  end
  object qryIngredients: TADOQuery
    Connection = conSlicenDice
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT * FROM tblRecipe')
    Left = 840
    Top = 88
  end
  object dsrIngredients: TDataSource
    DataSet = qryIngredients
    Left = 840
    Top = 152
  end
  object tblDietaryGoal: TADOTable
    Connection = conSlicenDice
    CursorType = ctStatic
    TableName = 'tblDietaryGoal'
    Left = 544
    Top = 88
  end
  object dsrDietaryGoal: TDataSource
    DataSet = tblDietaryGoal
    Left = 544
    Top = 152
  end
  object qryDietary: TADOQuery
    Connection = conSlicenDice
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT * FROM tblRecipe')
    Left = 912
    Top = 88
  end
  object dsrDietary: TDataSource
    DataSet = qryDietary
    Left = 912
    Top = 152
  end
  object tblFillRecIDArray: TADOTable
    Connection = conSlicenDice
    CursorType = ctStatic
    TableName = 'tblTrack'
    Left = 544
    Top = 208
  end
  object dsrFillRecIDArray: TDataSource
    DataSet = tblFillRecIDArray
    Left = 544
    Top = 272
  end
  object tblFillIngredientArray: TADOTable
    Connection = conSlicenDice
    CursorType = ctStatic
    TableDirect = True
    TableName = 'tblRecipeIngredientNeed'
    Left = 544
    Top = 328
  end
  object dsrFillIngredientArray: TDataSource
    DataSet = tblFillIngredientArray
    Left = 544
    Top = 392
  end
  object tblCheckIngredient: TADOTable
    Connection = conSlicenDice
    CursorType = ctStatic
    TableName = 'tblIngredient'
    Left = 216
    Top = 216
  end
  object dsrCheckIngredient: TDataSource
    DataSet = tblCheckIngredient
    Left = 216
    Top = 280
  end
end

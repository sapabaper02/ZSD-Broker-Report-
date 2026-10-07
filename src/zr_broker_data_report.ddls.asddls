@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root view for Broker Report'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZR_BROKER_DATA_REPORT
  as select from ZI_BROKER_DATA_A
{
  key BillingDocument,
  key BillingDocumentItem,
      BillingDocumentDate,
      @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
      BillingQuantity,
      BillingQuantityUnit,
      FiscalYear,
      AccountingDocument,
      SoldToParty,
      SoldToPartyName,
      PayerParty,
      PayerPartyName,
      BillToParty,
      BillToPartyName,
      CityName,
      DistrictName,
      BrokerName,
      BrokerCode,
      CommitionRate,
      TotalCommission,
      CustomerGST,
      RegionName,
      CountryName,
      ShipToParty,
      ShipToPartyName,
      TransactionCurrency,
      IncoTerms,
      CustomerPaymentTerms,
      CreatedByUser,
      PricingDate,
      OrganizationDivision,
      Product,
      ProductName,
      BillingDocumentType,
      OBD,
      OBDDate,
      SalesOrderNo,
      SalesOrderDate,
      HSNSac,
      ProfitCenter,
      SupplierGSTIN,
      PurchaseOrderByCustomer,
      Wbs,
      WbsDescription,
      Project,
      Reference,
      LRNo,
      GatePassNo,
      VehicleNumber,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      OilConvertionQty,
      WeightUnit,
      @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
      converted_value,
      Net_Qty,
      WaybillNumber,
      EinoviceNumber,
      ReversalEntryNo,
      Plant,
      CompanyCode
}

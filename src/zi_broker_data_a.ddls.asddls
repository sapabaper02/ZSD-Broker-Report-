@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for Broker Data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_BROKER_DATA_A
  as select from ZI_BROKER_DATA
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
      cast( BillingQuantity * CommitionRate as abap.dec( 18, 3 ) ) as TotalCommission,
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
      case
      when BillingQuantityUnit = 'KG'
      then cast( ( cast( BillingQuantity as abap.dec(13,3)) / 1000 ) * cast( converted_value as abap.dec(13,6) ) as abap.dec(13,5))
      else cast( cast( BillingQuantity as abap.dec(13,3) ) * cast( converted_value as abap.dec(13,6) ) as abap.dec(13,5) )
      end                                                          as Net_Qty,
      WaybillNumber,
      EinoviceNumber,
      ReversalEntryNo,
      Plant,
      CompanyCode

}

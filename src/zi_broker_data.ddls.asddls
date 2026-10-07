@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for Broker Data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_BROKER_DATA
  as select from    I_BillingDocumentItemBasic     as BillingItem
    left outer join I_BillingDocumentPartnerBasic  as PartnerBillToParty  on  PartnerBillToParty.BillingDocument = BillingItem.BillingDocument
                                                                          and PartnerBillToParty.PartnerFunction = 'RE'
    left outer join I_Customer                     as BillToParty         on BillToParty.Customer = PartnerBillToParty.Customer

    left outer join I_BillingDocumentPartnerBasic  as PartnerBrokerParty  on  BillingItem.BillingDocument        = PartnerBrokerParty.BillingDocument
                                                                          and PartnerBrokerParty.PartnerFunction = 'ZB'

    left outer join ZI_BROKER_RATE_MAINTENANCE     as BrokerRate          on  BillingItem.Product = BrokerRate.Material
                                                                          and BillingItem.Plant   = BrokerRate.Plant

    left outer join I_Customer                     as BrokerToParty       on BrokerToParty.Customer = PartnerBrokerParty.Customer

    left outer join I_BillingDocumentPartnerBasic  as PartnerShipToParty  on  PartnerShipToParty.BillingDocument = BillingItem.BillingDocument
                                                                          and PartnerShipToParty.PartnerFunction = 'AG'
    left outer join I_Customer                     as ShipToParty         on ShipToParty.Customer = PartnerShipToParty.Customer

    left outer join I_ProductPlantIntlTrd          as ProductPlantIntlTrd on  ProductPlantIntlTrd.Product = BillingItem.Product
                                                                          and ProductPlantIntlTrd.Plant   = BillingItem.Plant

    left outer join I_BillingDocItemPrcgElmntBasic as UnitRate            on  UnitRate.BillingDocument     = BillingItem.BillingDocument
                                                                          and UnitRate.BillingDocumentItem = BillingItem.BillingDocumentItem
    //                                                                            and UnitRate.ConditionType       = 'PPR0'
                                                                          and (
                                                                             UnitRate.ConditionType        = 'ZPR3' // Added On 16.12.2024
                                                                             //  or UnitRate.ConditionType     = 'ZPR1' //Removed On 18.12.2024
                                                                             //  or UnitRate.ConditionType     = 'ZPR0'
                                                                           )

    left outer join I_EnterpriseProjectElement_2   as Wbs                 on  Wbs.WBSElementInternalID =  BillingItem.WBSElementInternalID
                                                                          and Wbs.WBSElementInternalID <> '00000000'

    left outer join I_EnterpriseProject            as Project             on Project.ProjectInternalID = Wbs.ProjectInternalID

    left outer join I_SalesOrder                   as SalesOrder          on SalesOrder.SalesOrder = BillingItem.SalesDocument

    left outer join I_BillingDocumentBasic         as BillingCancelled    on BillingCancelled.CancelledBillingDocument = BillingItem.BillingDocument

    left outer join I_IN_ElectronicDocInvoice      as Einv                on Einv.ElectronicDocSourceKey = BillingItem.BillingDocument
    left outer join I_IN_ElectronicDocTransptRegn  as EwayBill            on EwayBill.ElectronicDocSourceKey = BillingItem.BillingDocument


{
  key BillingItem.BillingDocument,
  key BillingItem.BillingDocumentItem,
      BillingItem._BillingDocumentBasic.BillingDocumentDate,
      @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
      case  BillingItem._BillingDocumentBasic.BillingDocumentType
      when 'S1'
      then -( BillingItem.BillingQuantity )
      when 'G2'
      then -( BillingItem.BillingQuantity )
      else BillingItem.BillingQuantity end                                                                                    as BillingQuantity,
      BillingItem.BillingQuantityUnit,
      BillingItem._BillingDocumentBasic.FiscalYear,
      BillingItem._BillingDocumentBasic.AccountingDocument,
      BillingItem._BillingDocumentBasic.SoldToParty,
      BillingItem._BillingDocumentBasic._SoldToParty.CustomerName                                                             as SoldToPartyName,
      BillingItem._BillingDocumentBasic.PayerParty,
      BillingItem._BillingDocumentBasic._PayerParty.CustomerName                                                              as PayerPartyName,

      PartnerBillToParty.Customer                                                                                             as BillToParty,
      BillToParty.CustomerName                                                                                                as BillToPartyName,

      BillingItem._SoldToParty.CityName,
      BillingItem._SoldToParty.DistrictName,
      BrokerToParty.CustomerName                                                                                              as BrokerName,
      BrokerToParty.Customer                                                                                                  as BrokerCode,
      BrokerRate.Rate                                                                                                         as CommitionRate,

      BillToParty.TaxNumber3                                                                                                  as CustomerGST,
      BillingItem._BillingDocumentBasic._Region[ Country = 'IN' ]._RegionText[ Language = 'E' ].RegionName,
      BillingItem._BillingDocumentBasic._Country._Text[ Language = 'E' ].CountryName,

      PartnerShipToParty.Customer                                                                                             as ShipToParty,
      ShipToParty.CustomerName                                                                                                as ShipToPartyName,
      BillingItem._BillingDocumentBasic.TransactionCurrency,
      concat(BillingItem._BillingDocumentBasic.IncotermsClassification, BillingItem._BillingDocumentBasic.IncotermsLocation1) as IncoTerms,
      BillingItem._BillingDocumentBasic.CustomerPaymentTerms,
      BillingItem._BillingDocumentBasic.CreatedByUser,
      BillingItem.PricingDate,
      BillingItem.OrganizationDivision,
      BillingItem.Product,
      BillingItem._ProductText[ Language = 'E' ].ProductName,
      BillingItem._BillingDocumentBasic.BillingDocumentType,

      case when BillingItem.ReferenceSDDocumentCategory = 'J'
        then BillingItem.ReferenceSDDocument
        else ''
        end                                                                                                                   as OBD,

      case when BillingItem.ReferenceSDDocumentCategory = 'J'
      then BillingItem._ReferenceDeliveryDocumentItem._DeliveryDocument.ActualGoodsMovementDate
      else ''
      end                                                                                                                     as OBDDate,

      case when BillingItem.SalesSDDocumentCategory = 'C'
        then BillingItem.SalesDocument
        else ''
        end                                                                                                                   as SalesOrderNo,

      SalesOrder.SalesOrderDate                                                                                               as SalesOrderDate,
      ProductPlantIntlTrd.ConsumptionTaxCtrlCode                                                                              as HSNSac,
      BillingItem.ProfitCenter,
      ''                                                                                                                      as SupplierGSTIN,
      SalesOrder.PurchaseOrderByCustomer,

      BillingItem.WBSElementInternalID                                                                                        as Wbs,
      Wbs.ProjectElementDescription                                                                                           as WbsDescription,
      Project.Project                                                                                                         as Project,

      BillingItem._BillingDocumentBasic.DocumentReferenceID                                                                   as Reference,
      BillingItem._BillingDocumentBasic.YY1_LRNo_BDH                                                                          as LRNo,
      BillingItem._BillingDocumentBasic.YY1_GatePassNo_BDH                                                                    as GatePassNo,
      BillingItem._BillingDocumentBasic.YY1_VehNum_BDH                                                                        as VehicleNumber,

      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      BillingItem._Product.NetWeight                                                                                          as OilConvertionQty,
      BillingItem._Product.WeightUnit,

      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      case
      when BillingItem._Product.WeightUnit = 'KG'
      then BillingItem._Product.NetWeight / 1000
      else BillingItem._Product.NetWeight end                                                                                 as converted_value,
      cast( 0 as abap.dec(13,5))                                                                                              as Net_Qty,
      EwayBill.IN_ElectronicDocEWbillNmbr                                                                                     as WaybillNumber,
      Einv.IN_EDocEInvcExtNmbr                                                                                                as EinoviceNumber,
      BillingCancelled.BillingDocument                                                                                        as ReversalEntryNo,
      BillingItem.Plant,
      BillingItem.CompanyCode


}

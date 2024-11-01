tableextension 50101 "Purchase From Sales Order" extends "Requisition Line"
{
    fields
    {
        field(50100; Margins; Decimal)
        {
            Caption = 'Margins';
            DataClassification = ToBeClassified;
        }
    }
}

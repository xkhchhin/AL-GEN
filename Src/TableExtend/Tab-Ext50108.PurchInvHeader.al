tableextension 50108 "Purch. Inv. Header" extends "Purch. Inv. Header"
{
    fields
    {
        field(50100; "OldInvoiceNo"; code[20])
        {
            Caption = '';
            DataClassification = ToBeClassified;
        }
        field(50101; "NewInvoiceNo"; code[20])
        {
            Caption = '';
            DataClassification = ToBeClassified;
        }
    }
}

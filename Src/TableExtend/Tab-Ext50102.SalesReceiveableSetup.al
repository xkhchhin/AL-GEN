tableextension 50102 "Sales & Receiveable Setup" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50100; "pmt. discount account"; Code[20])
        {
            Caption = 'Pmt. Discount Account';
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No." where("Direct Posting" = const(true));
        }
    }
}

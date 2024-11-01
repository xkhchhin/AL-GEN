page 50106 "Modify Invoice Dialog"
{
    Caption = 'Modify Invoice Dialog';
    PageType = StandardDialog;
    SourceTable = "Purch. Inv. Header";

    layout
    {
        area(content)
        {
            group(Group)
            {
                field(OldInvoiceNo; Rec.OldInvoiceNo)
                {
                    ApplicationArea = All;
                    Caption = 'Old Invoice No.';
                    Editable = false; // This should be read-only
                }

                field(NewInvoiceNo; Rec.NewInvoiceNo)
                {
                    ApplicationArea = All;
                    Caption = 'New Invoice No.';
                }
            }
        }
    }
    var
        OldInvoiceNo: Code[20];
        NewInvoiceNo: Code[20];
}

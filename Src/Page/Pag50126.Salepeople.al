page 50126 Salepeople
{
    ApplicationArea = All;
    Caption = 'Salepeople';
    PageType = List;
    SourceTable = Salepeople;
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                ShowCaption = false;//I hope you happy but don't be happier
                field("Salepeople code"; Rec."Salepeople code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the Salepeople numbers that are displayed in the Salepeople Cue on the Role Center.';
                    Width = 4;

                    trigger OnValidate()
                    begin
                        SyncFieldsWithCustomer;
                    end;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Name';
                    DrillDown = false;
                    Lookup = false;
                    ToolTip = 'Specifies the name of the customer.';
                    Width = 20;
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Phone No.';
                    DrillDown = false;
                    ExtendedDatatype = PhoneNo;
                    Lookup = false;
                    ToolTip = 'Specifies the customer''s phone number.';
                    Width = 8;
                }
                field("Amount (LCY)"; Rec."Amount (LCY)")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the payment amount that the customer owes for completed sales.';

                    trigger OnDrillDown()
                    begin
                        Customer.OpenCustomerLedgerEntries(false);
                    end;
                }
            }
        }
    }
    var
        Salepeople: Record "Salesperson/Purchaser";
        Customer: Record Customer;

    local procedure SyncFieldsWithCustomer()
    var
        Salepeoples: Record Salepeople;
    begin
        Clear(Salepeople);

        // if Salepeoples.Get("Salepeople code") then
        //     if (Name <> Customer.Name) or ("Phone No." <> Customer."Phone No.") then begin
        //         Name := Customer.Name;
        //         "Phone No." := Customer."Phone No.";
        //         if MyCustomer.Get("User ID", "Customer No.") then
        //             Modify;
        //     end;
    end;
}

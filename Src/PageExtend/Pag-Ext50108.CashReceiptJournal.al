pageextension 50108 "Cash Receipt Journal" extends "Cash Receipt Journal"
{
    layout
    {
        addafter("Applies-to ID")
        {

        }
    }
    actions
    {
        addafter("Apply Entries")
        {
            action("Calculate Discount")
            {
                ApplicationArea = All;
                Caption = 'Calculate Discount', comment = 'NLB="YourLanguageCaption"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Calculate;
                trigger OnAction()
                begin
                    Caculatediscount();
                end;
            }
        }
    }
    procedure Caculatediscount()
    var
        XtrSetsup: Record "Sales & Receivables Setup";
        GjBatch: Record "Gen. Journal Batch";
        GjLine: Record "Gen. Journal Line";
        Nextno: Integer;
        CustAmt: Decimal;
        AppliedToDocNo: Code[20];
    begin
        CustAmt := GetAmountCustomerLedgerEntries(rec."Account No.", Rec."Applies-to Doc. No.");
        AppliedToDocNo := GetAppliedToDocumentNo(rec."Applies-to Doc. No.");
        Nextno := 0;
        XtrSetsup.Get();
        XtrSetsup.TestField("pmt. discount account");
        GjBatch.SetRange("Template Type", GjBatch."Template Type"::"Cash Receipts");
        GjBatch.SetRange("Journal Template Name", rec."Journal Template Name");
        GjBatch.SetRange(Name, rec."Journal Batch Name");
        if GjBatch.Find('-') then begin
            GjLine.SetRange("Journal Batch Name", GjBatch.Name);
            GjLine.SetRange("Document Type", rec."Document Type"::Payment);
            GjLine.SetRange("Journal Template Name", rec."Journal Template Name");
            Nextno := GjLine.GetNewLineNo(GjBatch."Journal Template Name", GjBatch.Name);
            if GjLine.Find('-') then begin
                GjLine."Line No." := Nextno;
                GjLine."Posting Date" := rec."Posting Date";
                GjLine.Insert(true);
            end;
        end;
        Message('Customer Amount:', AppliedToDocNo);
    end;
    //Get Amount From Customer ledger entries
    procedure GetAmountCustomerLedgerEntries(var CustNo: code[20]; DocNo: Code[20]): Decimal
    var
        CustomerLedgerentries: Record "Cust. Ledger Entry";
    begin
        CustomerLedgerentries.Reset();
        CustomerLedgerentries.SetRange("Customer No.", CustNo);
        CustomerLedgerentries.SetRange("Document No.", DocNo);
        if CustomerLedgerentries.Find('-') then begin
            CustomerLedgerentries.CalcFields(Amount);
            exit(CustomerLedgerentries.Amount)
        end;
    end;
    //Get Applied to document no.
    procedure GetAppliedToDocumentNo(var DocNo: Code[20]): Code[20]
    var
        CustLedgerEntries: Record "Cust. Ledger Entry";
    begin
        CustLedgerEntries.Reset();
        CustLedgerEntries.SetRange("Document No.", DocNo);
        if CustLedgerEntries.Find('-') then begin
            exit(CustLedgerEntries."Document No.");
        end;
    end;
}

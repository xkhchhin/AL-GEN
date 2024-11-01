pageextension 50117 "Item Ledger Entries" extends "Item Ledger Entries"
{

    layout
    {
        addafter("Item No.")
        {
            field(GetItemDescription; GetItemDescription(rec."Item No."))
            {
                ApplicationArea = all;
            }
        }
        modify(Description)
        {
            Visible = false;
        }
        addafter("Location Code")
        {
            field(OptionType; Rec.OptionType)
            {
                ApplicationArea = all;
            }
            field("Student Name"; Rec."Student Name")
            {
                ApplicationArea = all;
            }
            field("Reclass to Location Code"; Rec."Reclass to Location Code")
            {
                ApplicationArea = all;
            }
            field("Reclass to Bin Code"; Rec."Reclass to Bin Code")
            {
                ApplicationArea = all;
            }
        }
        addafter("Lot No.")
        {
            field("No of Days (Today-Exp. Date)"; Rec."No of Days (Today-Exp. Date)")
            {
                Visible = FeatureEnable;
                StyleExpr = OverExpiryDate_NoOfDayColorExpression;
                ApplicationArea = All;
            }
            field("Item Expiration Category"; Rec."Item Expiration Category")
            {
                Visible = FeatureEnable;
                ApplicationArea = All;
            }
            field("Expiration Category Level"; Rec."Expiration Category Level")
            {
                Visible = FeatureEnable;
                ApplicationArea = All;
                StyleExpr = RangeStyleExprTxt;
            }
        }
    }
    actions
    {
        addlast(processing)
        {
            action(CalculateDays)
            {
                ApplicationArea = All;
                Caption = 'Calculate No. Days';
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                begin
                    NoofDaysFromToday2ExpirationDate := 0;
                    NoofDaysReceiptDate2Today := 0;
                    NoofDaysReceiptDate2Today := Today - Rec."Posting Date";
                    NoofDaysFromToday2ExpirationDate := Rec."Expiration Date" - Today();
                    Rec."No of Days (RcptDate-Today)" := Today - Rec."Posting Date";
                    Rec."No of Days (Today-Exp. Date)" := Rec."Expiration Date" - Today();
                end;

            }
        }
        addafter("Ent&ry")
        {
            action(CreateTransferOrder)
            {
                ApplicationArea = All;
                Caption = 'Create Transfer', comment = 'NLB="YourLanguageCaption"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = TransferOrder;

                trigger OnAction()
                var
                    CreateTransferOrder: Report "Create Transfer Order";
                    TransferOrderList: Page "Transfer Orders";
                    ItemLedgerEntry: Record "Item Ledger Entry";
                begin
                    ItemLedgerEntry.Reset();
                    CurrPage.SetSelectionFilter(ItemLedgerEntry);
                    CreateTransferOrder.SetTableView(ItemLedgerEntry);
                    CreateTransferOrder.PrerequisitInfo(Rec."Location Code");
                    CreateTransferOrder.Run();
                end;
            }
            action(CreateTransferOrder2)
            {
                ApplicationArea = All;
                Caption = 'Create Transfer 2', comment = 'NLB="YourLanguageCaption"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = TransferOrder;

                trigger OnAction()
                var
                    CreateTransferOrder: Report "Create Transfer Order";
                begin
                    CreateTransferOrder();
                end;
            }
        }
    }
    procedure CreateTransferOrder()
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        TransferHeader: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
        ItemRec: Record Item;
        NextLineNo: Integer;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        TransferFromLocation: Code[10];
        DocumentNo: code[20];
    begin
        // Ensure at least one record is selected
        if not ItemLedgEntry.Get(Rec."Entry No.") then
            Error('No Item Ledger Entry selected.');
        TransferFromLocation := ItemLedgEntry."Location Code";
        // Initialize Transfer Header
        TransferHeader.Init();
        TransferHeader."Posting Date" := WorkDate;
        TransferHeader."Transfer-from Code" := TransferFromLocation;
        TransferHeader."Transfer-to Code" := 'Blue'; // Specify a new location
        TransferHeader."In-Transit Code" := 'OUT. LOG.';
        TransferHeader.Insert(true);

        // Set initial Line No.
        NextLineNo := 10000;
        TransferLine.Reset();
        TransferLine.SetRange("Document No.", TransferHeader."No.");
        TransferLine.SetRange("Transfer-from Code", TransferHeader."Transfer-from Code");
        TransferLine.SetRange("Transfer-to Code", TransferHeader."Transfer-to Code");
        TransferLine.Reset();
        TransferLine.Init();
        TransferLine."Document No." := TransferHeader."No.";
        TransferLine."Line No." := NextLineNo;  // Set Line No.
        TransferLine."Item No." := ItemLedgEntry."Item No.";
        TransferLine.Quantity := ItemLedgEntry.Quantity;
        TransferLine."Unit of Measure Code" := ItemLedgEntry."Unit of Measure Code";
        TransferLine.Insert();
        TransferLine.Validate("Item No.", ItemLedgEntry."Item No.");
        TransferLine.Modify(true);
        NextLineNo := NextLineNo + 10000;
        Message('Transfer-from code %1.', TransferFromLocation);
        Message('Transfer-to code %1.', TransferHeader."Transfer-to Code");
        Message('Transfer Order %1 created successfully.', TransferHeader."No.");
    end;

    local procedure SetOverExpiryDate_NoOfDayColor()
    begin
        if Rec."No of Days (Today-Exp. Date)" < 0 then
            OverExpiryDate_NoOfDayColorExpression := 'Unfavorable'
        else
            OverExpiryDate_NoOfDayColorExpression := 'Standard';
    end;

    trigger OnAfterGetRecord()
    begin
        SetOverExpiryDate_NoOfDayColor();
        RangeStyleExprTxt := ChangeRankColor(Rec."Expiration Category Level");
    end;

    procedure ChangeRankColor(RangStyle: enum "Invt. Expiration Range Style"): Text[50]
    var
        myInt: Integer;
    begin
        case RangStyle of
            RangStyle::Red:
                exit('Unfavorable');
            RangStyle::Green:
                exit('Favorable');
            RangStyle::Orange:
                exit('Ambiguous');
            RangStyle::None:
                exit('Subordinate');
        end;
    end;

    trigger OnOpenPage()
    var
        InventorySetup: Record "Inventory Setup";
    begin
        InventorySetup.Get();
        if InventorySetup."Exp. Category Feature" = true then
            FeatureEnable := true
        else
            FeatureEnable := false;
    end;

    local procedure GetItemDescription(Itemno: Code[20]): text[100]
    var
        item: Record Item;
    begin
        item.reset();
        item.SetRange("No.", Itemno);
        if item.Find('-') then
            exit(item.Description);
    end;

    var
        OverExpiryDate_NoOfDayColorExpression: Text;
        InventorySetup: Record "Inventory Setup";
        FeatureEnable: Boolean;
        RangStyle: enum "Invt. Expiration Range Style";
        StyleOption: Option "None","Green","Red","Orange";
        RangeStyleExprTxt: Text[50];
        NoofDaysReceiptDate2Today: Duration;
        NoofDaysFromToday2ExpirationDate: Duration;
}

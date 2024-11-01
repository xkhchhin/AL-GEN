page 50121 " Inventory Expiration Mgt."
{
    ApplicationArea = All;
    Caption = ' Inventory Expiration Mgt.';
    PageType = List;
    SourceTable = "Inventory Expiration Mgt.";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
            }
            part("Expiration Cue"; "Expiration Cue")
            {
                ApplicationArea = all;
            }
            part(Expiration; "Item Ledger Entry")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            group(Processings)
            {
                action("Item Expiration Category")
                {
                    ApplicationArea = All;
                    Caption = 'Item Expiration Category', comment = 'NLB="YourLanguageCaption"';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Category;

                    trigger OnAction()
                    var
                        ItemExpirationCategory: Page "Item Expiration Category";
                    begin
                        ItemExpirationCategory.Run();
                    end;
                }
                action(Setup)
                {
                    ApplicationArea = All;
                    Caption = 'Setup', comment = 'NLB="YourLanguageCaption"';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Setup;
                    RunObject = page "Inventory Expiration Mgt List";

                    trigger OnAction()
                    var
                    begin
                    end;
                }
                action(Refresh)
                {
                    ApplicationArea = All;
                    Caption = 'Refresh', comment = 'NLB="YourLanguageCaption"';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Refresh;

                    trigger OnAction()
                    var
                        InventoryExpiration: Codeunit RefreshLotWithExpiration;
                    begin
                        InventoryExpiration.RefreshEntries();
                    end;
                }
                action(GenerateReport)
                {
                    ApplicationArea = All;
                    Caption = 'Generate Report', comment = 'NLB="YourLanguageCaption"';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Image = Report;

                    trigger OnAction()
                    var
                    begin
                    end;
                }
            }
            group(Funtion)
            {
                action(CreateTransferOrder)
                {
                    ApplicationArea = All;
                    Caption = 'Create Transfer Order', comment = 'NLB="YourLanguageCaption"';
                    Promoted = true;
                    PromotedCategory = Category11;
                    PromotedIsBig = true;
                    Image = TransferOrder;

                    trigger OnAction()
                    var
                    begin
                    end;
                }
                action(CreateInventoryAdjustment)
                {
                    ApplicationArea = All;
                    Caption = 'Create Inventory Adjustment', comment = 'NLB="YourLanguageCaption"';
                    Promoted = true;
                    PromotedCategory = Category11;
                    PromotedIsBig = true;
                    Image = InventoryJournal;

                    trigger OnAction()
                    var
                    begin
                    end;
                }
                action(CreateCampaing)
                {
                    ApplicationArea = All;
                    Caption = 'Create Campaing', comment = 'NLB="YourLanguageCaption"';
                    Promoted = true;
                    PromotedCategory = Category11;
                    PromotedIsBig = true;
                    Image = Campaign;

                    trigger OnAction()
                    var
                    begin
                    end;
                }
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        InventoryManagement: Record "Inventory Expiration Mgt.";
        LastEntryNo: Integer;
    begin
        InventoryManagement.Reset();
        LastEntryNo := 0;
        if InventoryManagement.FindLast()
        then
            LastEntryNo := InventoryManagement."Entry No." + 1;
        Rec."Entry No." := LastEntryNo;
        Rec.Modify(true);
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

    trigger OnAfterGetRecord()
    begin
        LowRangeStyleExprTxt := ChangeRankColor(Rec."Low Range");
        MiddleRangeStyleExprTxt := ChangeRankColor(Rec."Middle Range");
        HighRangeStyleExprTxt := ChangeRankColor(Rec."High Range");
        WriteOffRangeStyleExprTxt := ChangeRankColor(Rec."Write Off Range")
    end;

    trigger OnOpenPage()
    begin
        Rec.InsertIfNotExists();
    end;

    var

        RangStyle: enum "Invt. Expiration Range Style";
        StyleOption: Option "None","Green","Red","Orange";
        LowRangeStyleExprTxt: Text[50];
        MiddleRangeStyleExprTxt: Text[50];
        HighRangeStyleExprTxt: Text[50];
        WriteOffRangeStyleExprTxt: Text[50];
}

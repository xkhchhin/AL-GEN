page 50123 "Expiration Cue"
{
    Caption = 'Expiration Chart & Cue';
    PageType = ListPart;
    SourceTable = "Invt. Threshold Cue";

    layout
    {
        area(Content)
        {
            grid(ExpiarationCue)
            {
                usercontrol(Chart; "Microsoft.Dynamics.Nav.Client.BusinessChart")
                {
                    ApplicationArea = all;
                    trigger DataPointClicked(point: JsonObject)
                    var
                        JsonTxt: Text;
                    begin
                        point.WriteTo(JsonTxt);
                        Message('%1', JsonTxt);
                    end;

                    trigger AddInReady()
                    var
                        Buffer: Record "Business Chart Buffer" temporary;
                        ExpirationMangement: Record "Inventory Expiration Mgt.";
                        InventoryExpManagementCue: Record "Invt. Threshold Cue";
                        InventoryStyle: Enum "Invt. Expiration Range Style";
                        i: Integer;
                    begin
                        ExpirationMangement.Get();
                        I := 0;
                        Buffer.Initialize();
                        // Index 0
                        Buffer.AddMeasure(Format(ExpirationMangement."High Range"), 1, Buffer."Data Type"::Decimal, Buffer."Chart Type"::Column);
                        // Index 1
                        Buffer.AddMeasure(Format(ExpirationMangement."Middle Range"), 2, Buffer."Data Type"::Decimal, Buffer."Chart Type"::Column);
                        // Index 2
                        Buffer.AddMeasure(Format(ExpirationMangement."Low Range"), 3, Buffer."Data Type"::Decimal, Buffer."Chart Type"::Column);
                        // Index 3
                        Buffer.AddMeasure(Format(ExpirationMangement."Write Off Range"), 4, Buffer."Data Type"::Decimal, Buffer."Chart Type"::Column);
                        Buffer.SetXAxis('Category', Buffer."Data Type"::String);
                        InventoryExpManagementCue.CalcFields(Green, Gray, Red, Orange);
                        Buffer.AddColumn(Format(ExpirationMangement."High Range"));
                        Buffer.AddColumn(Format(ExpirationMangement."Middle Range"));
                        Buffer.AddColumn(Format(ExpirationMangement."Low Range"));
                        Buffer.AddColumn(Format(ExpirationMangement."Write Off Range"));
                        case ExpirationMangement."High Range" of
                            "Invt. Expiration Range Style"::Green:
                                begin
                                    Buffer.SetValueByIndex(0, 0, InventoryExpManagementCue.Green);
                                end;
                            "Invt. Expiration Range Style"::Red:
                                begin
                                    Buffer.SetValueByIndex(0, 0, InventoryExpManagementCue.Red);
                                end;
                            "Invt. Expiration Range Style"::Orange:
                                begin
                                    Buffer.SetValueByIndex(0, 0, InventoryExpManagementCue.Orange);
                                end;
                            "Invt. Expiration Range Style"::None:
                                begin
                                    Buffer.SetValueByIndex(0, 0, InventoryExpManagementCue.Gray);
                                end;
                        end;
                        case ExpirationMangement."Middle Range" of
                            "Invt. Expiration Range Style"::Green:
                                begin
                                    Buffer.SetValueByIndex(0, 1, InventoryExpManagementCue.Green);
                                end;
                            "Invt. Expiration Range Style"::Red:
                                begin
                                    Buffer.SetValueByIndex(0, 1, InventoryExpManagementCue.Red);
                                end;
                            "Invt. Expiration Range Style"::Orange:
                                begin
                                    Buffer.SetValueByIndex(0, 1, InventoryExpManagementCue.Orange);
                                end;
                            "Invt. Expiration Range Style"::None:
                                begin
                                    Buffer.SetValueByIndex(0, 1, InventoryExpManagementCue.Gray);
                                end;
                        end;
                        case ExpirationMangement."Low Range" of
                            "Invt. Expiration Range Style"::Green:
                                begin
                                    Buffer.SetValueByIndex(0, 2, InventoryExpManagementCue.Green);
                                end;
                            "Invt. Expiration Range Style"::Red:
                                begin
                                    Buffer.SetValueByIndex(0, 2, InventoryExpManagementCue.Red);
                                end;
                            "Invt. Expiration Range Style"::Orange:
                                begin
                                    Buffer.SetValueByIndex(0, 2, InventoryExpManagementCue.Orange);
                                end;
                            "Invt. Expiration Range Style"::None:
                                begin
                                    Buffer.SetValueByIndex(0, 2, InventoryExpManagementCue.Gray);
                                end;
                        end;
                        case ExpirationMangement."Write Off Range" of
                            "Invt. Expiration Range Style"::Green:
                                begin
                                    Buffer.SetValueByIndex(0, 3, InventoryExpManagementCue.Green);
                                end;
                            "Invt. Expiration Range Style"::Red:
                                begin
                                    Buffer.SetValueByIndex(0, 3, InventoryExpManagementCue.Red);
                                end;
                            "Invt. Expiration Range Style"::Orange:
                                begin
                                    Buffer.SetValueByIndex(0, 3, InventoryExpManagementCue.Orange);
                                end;
                            "Invt. Expiration Range Style"::None:
                                begin
                                    Buffer.SetValueByIndex(0, 3, InventoryExpManagementCue.Gray);
                                end;
                        end;
                        Buffer.Update(CurrPage.Chart);
                    end;
                }
                group(Cue)
                {
                    ShowCaption = false;
                    cuegroup(Generals)
                    {
                        CuegroupLayout = Wide;
                        Caption = 'Inventory Expiration Management Cue';
                        field(Green; Rec.Green)
                        {
                            ApplicationArea = All;
                            StyleExpr = 'Favorable';
                            ToolTip = 'Specifies the value of the Green field.', Comment = '%';
                        }
                        field(Orange; Rec.Orange)
                        {
                            ApplicationArea = All;
                            StyleExpr = 'Ambiguous';
                            ToolTip = 'Specifies the value of the Orange field.', Comment = '%';
                        }
                        field(Red; Rec.Red)
                        {
                            ApplicationArea = All;
                            StyleExpr = 'Unfavorable';
                            ToolTip = 'Specifies the value of the Red field.', Comment = '%';
                        }
                        field(Gray; Rec.Gray)
                        {
                            ApplicationArea = All;
                            StyleExpr = 'Subordinate';
                            ToolTip = 'Specifies the value of the Gray field.', Comment = '%';
                        }
                        field(Gray1; Rec.Gray)
                        {
                            ApplicationArea = All;
                            Caption = 'TestCue';
                            StyleExpr = 'Subordinate';
                            ToolTip = 'Specifies the value of the Gray field.', Comment = '%';
                        }
                    }
                }
            }
            repeater(General)
            {

            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.InsertIfNotExists();
    end;
}

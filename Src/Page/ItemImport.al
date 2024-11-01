page 50107 Items
{
    PageType = List;
    //ApplicationArea = All;
    //UsageCategory = Lists;
    SourceTable = ItemTbl;
    SourceTableView = sorting("No.");
    DelayedInsert = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    SaveValues = true;
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Search Description"; Rec."Search Description")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field(Inventory; Rec.Inventory)
                {
                    ApplicationArea = All;
                }
                field("Base Unit of Measure"; Rec."Base Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                }

            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(Import)
            {
                ApplicationArea = All;
                Caption = 'Import', comment = 'NLB="YourLanguageCaption"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Import;

                trigger OnAction()
                begin
                    ReadExcelSheet();
                end;
            }
        }
    }
    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    begin
        TempExelBuffer.Reset();
        if TempExelBuffer.Get(RowNo, ColNo) then
            exit(TempExelBuffer."Cell Value as Text")
        else
            exit('');
    end;

    local procedure ReadExcelSheet()
    var
        FileManagement: Codeunit "File Management";
        Istream: InStream;
        FromFile: Text[10];
    begin
        UploadIntoStream(UploadMsg, '', '', FromFile, Istream);
        if FromFile <> '' then begin
            FileName := FileManagement.GetFileName(FromFile);
            SheetName := TempExelBuffer.SelectSheetsNameStream(Istream);

        end else
            Error(NoFileMsg);
        TempExelBuffer.Reset();
        TempExelBuffer.DeleteAll();
        TempExelBuffer.OpenBookStream(Istream, SheetName);
        TempExelBuffer.ReadSheet();
        ImportExcelData();
    end;

    local procedure ImportExcelData()
    var
        GSImportBuffer: Record ItemTbl;
        RowNo: Integer;
        ColNo: Integer;
        LineNo: Integer;
        MaxRow: Integer;
        DocNo: Code[24];
        Desc: Text[50];
    //con: text[100];
    begin
        RowNo := 0;
        ColNo := 0;
        MaxRow := 0;
        LineNo := 0;


        TempExelBuffer.Reset();
        if TempExelBuffer.FindLast() then begin
            MaxRow := TempExelBuffer."Row No.";
            TempExelBuffer.Reset();
        end;

        for RowNo := 2 to MaxRow do begin
            Evaluate(DocNo, GetValueAtCell(RowNo, 1));
            Evaluate(Desc, GetValueAtCell(RowNo, 2));
            //Evaluate(qty, GetValueAtCell(RowNo, 6));
            LineNo := LineNo + 10000;
            GSImportBuffer.SetRange("No.", DocNo);
            if not GSImportBuffer.Find('-') then begin
                GSImportBuffer.Init();
                // Evaluate(GSImportBuffer."Batch Name", BatchName);
                GSImportBuffer."No." := DocNo;
                Evaluate(GSImportBuffer."No.", GetValueAtCell(RowNo, 1));
                Evaluate(GSImportBuffer.Description, GetValueAtCell(RowNo, 2));
                Evaluate(GSImportBuffer."Search Description", GetValueAtCell(RowNo, 3));
                Evaluate(GSImportBuffer.Type, GetValueAtCell(RowNo, 4));
                Evaluate(GSImportBuffer.Inventory, GetValueAtCell(RowNo, 5));
                Evaluate(GSImportBuffer."Base Unit of Measure", GetValueAtCell(RowNo, 6));
                Evaluate(GSImportBuffer."Unit Cost", GetValueAtCell(RowNo, 7));
                Evaluate(GSImportBuffer."Unit Price", GetValueAtCell(RowNo, 8));
                Evaluate(GSImportBuffer."Vendor No.", GetValueAtCell(RowNo, 9));
                //GSImportBuffer."Sheet Name" := SheetName;
                //GSImportBuffer.Imported_Time := time;
                GSImportBuffer.Insert();
            end else begin//if it's existed
                GSImportBuffer.Validate(Description, Desc);

                GSImportBuffer.Modify();
            end;

        end;
        Message(ExcelImportSuccess);

    end;

    var
        FileName: Text[50];
        SheetName: Text[50];
        TempExelBuffer: Record "Excel Buffer" temporary;
        UploadMsg: Label 'Please Choose The Excel File';
        NoFileMsg: Label 'No Excel File Found';
        ExcelImportSuccess: Label 'Excel Import Success';
        ImaportBufferTbl: Record ImportBuffer;
}
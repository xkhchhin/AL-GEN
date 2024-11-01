page 50119 ImportWorkSheet
{
    PageType = Document;
    ApplicationArea = All;
    SourceTableView = sorting("Batch Name", "Line No.");
    UsageCategory = Tasks;
    SourceTable = ImportBuffer;
    DelayedInsert = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    SaveValues = true;
    AutoSplitKey = true;


    layout
    {
        area(Content)
        {
            field(BatchName; BatchName)
            {
                ApplicationArea = all;
            }
            repeater(GroupName)
            {
                Editable = false;

                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = all;
                }

                // field(Posting_Date; Rec.Posting_Date)
                // {
                //     ApplicationArea = all;
                // }
                // field(Currency_Code; Rec.Currency_Code)
                // {
                //     ApplicationArea = all;
                // }
                field(Document_Date; Rec.Document_Date)
                {
                    ApplicationArea = all;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = all;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = all;
                }
                field(File_Name; Rec.File_Name)
                {
                    ApplicationArea = all;
                }
                field("Sheet Name"; Rec."Sheet Name")
                {
                    ApplicationArea = all;
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
            action("&Import")
            {
                ApplicationArea = All;
                Caption = 'Import';
                Image = ImportExcel;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Import Data From Excel';

                trigger OnAction();
                begin
                    if BatchName = '' then
                        Error(BatchIsBlankMsg);
                    ReadExcelSheet();
                    // ImportExcelData();

                end;
            }
            action(Export)
            {
                ApplicationArea = All;
                Caption = 'Export', comment = 'NLB="YourLanguageCaption"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Export;
                ToolTip = 'Export To Excel';

                trigger OnAction()
                begin
                    ExportExcel(Rec);
                end;
            }
        }
    }
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

    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    begin
        TempExelBuffer.Reset();
        if TempExelBuffer.Get(RowNo, ColNo) then
            exit(TempExelBuffer."Cell Value as Text")
        else
            exit('');
    end;


    local procedure ImportExcelData()
    var
        GSImportBuffer: Record ImportBuffer;
        RowNo: Integer;
        ColNo: Integer;
        LineNo: Integer;
        MaxRow: Integer;
        DocNo: Code[24];
        Qty: Decimal;
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
            Evaluate(Qty, GetValueAtCell(RowNo, 4));
            LineNo := LineNo + 10000;
            GSImportBuffer.SetRange("Document No.", DocNo);
            if not GSImportBuffer.Find('-') then begin
                GSImportBuffer.Init();
                // Evaluate(GSImportBuffer."Batch Name", BatchName);
                GSImportBuffer."Line No." := LineNo;
                Evaluate(GSImportBuffer."Document No.", GetValueAtCell(RowNo, 1));
                Evaluate(GSImportBuffer."Sell-to Customer No.", GetValueAtCell(RowNo, 2));
                Evaluate(GSImportBuffer.Document_Date, GetValueAtCell(RowNo, 3));
                Evaluate(GSImportBuffer.Quantity, GetValueAtCell(RowNo, 4));
                Evaluate(GSImportBuffer."Unit Price", GetValueAtCell(RowNo, 5));
                GSImportBuffer."Sheet Name" := SheetName;
                GSImportBuffer.File_Name := FileName;
                GSImportBuffer.Imported_Date := Today;
                GSImportBuffer.Imported_Time := time;
                GSImportBuffer.Insert();
            end else begin//if it's existed
                GSImportBuffer.Validate(Quantity, Qty);

                GSImportBuffer.Modify();
            end;

        end;
        Message(ExcelImportSuccess);

    end;

    local procedure ExportExcel(var GSExcel: Record ImportBuffer)
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        GSExcelLbl: Label 'GS Excel Entries';
        GSFileName: Label 'GS Excel Entries_%1_%2';
    begin
        TempExelBuffer.Reset();
        TempExelBuffer.DeleteAll();
        TempExelBuffer.NewRow();

        TempExelBuffer.AddColumn(GSExcel.FieldCaption("Document No."), false, '', false, false, false, '', TempExelBuffer."Cell Type"::Text);
        TempExelBuffer.AddColumn(GSExcel.FieldCaption("Sell-to Customer No."), false, '', false, false, false, '', TempExelBuffer."Cell Type"::Text);
        TempExelBuffer.AddColumn(GSExcel.FieldCaption(Document_Date), false, '', false, false, false, '', TempExelBuffer."Cell Type"::Text);
        TempExelBuffer.AddColumn(GSExcel.FieldCaption(Quantity), false, '', false, false, false, '', TempExelBuffer."Cell Type"::Text);
        TempExelBuffer.AddColumn(GSExcel.FieldCaption("Unit Price"), false, '', false, false, false, '', TempExelBuffer."Cell Type"::Text);
        TempExelBuffer.AddColumn(GSExcel.FieldCaption("Document No."), false, '', false, false, false, '', TempExelBuffer."Cell Type"::Text);

        if GSExcel.FindSet() then
            repeat
                TempExelBuffer.NewRow();
                TempExelBuffer.AddColumn(GSExcel."Document No.", false, '', false, false, false, '', TempExelBuffer."Cell Type"::Text);
                TempExelBuffer.AddColumn(GSExcel."Sell-to Customer No.", false, '', false, false, false, '', TempExelBuffer."Cell Type"::Text);
                TempExelBuffer.AddColumn(GSExcel.Document_Date, false, '', false, false, false, '', TempExelBuffer."Cell Type"::Text);
                TempExelBuffer.AddColumn(GSExcel.Quantity, false, '', false, false, false, '', TempExelBuffer."Cell Type"::Text);
                TempExelBuffer.AddColumn(GSExcel."Unit Price", false, '', false, false, false, '', TempExelBuffer."Cell Type"::Text);
            until GSExcel.Next() = 0;

        TempExelBuffer.CreateNewBook(GSExcelLbl);
        TempExelBuffer.WriteSheet(GSExcelLbl, CompanyName, UserId);
        TempExelBuffer.CloseBook();
        TempExelBuffer.SetFriendlyFilename(StrSubstNo(GSFileName, CurrentDateTime, UserId));
        TempExelBuffer.OpenExcel();
    end;

    var
        BatchName: code[10];
        FileName: Text[50];
        SheetName: Text[50];
        TempExelBuffer: Record "Excel Buffer" temporary;
        UploadMsg: Label 'Please Choose The Excel File';
        NoFileMsg: Label 'No Excel File Found';
        BatchIsBlankMsg: Label 'Batch is blank';
        ExcelImportSuccess: Label 'Excel Import Success';
        ImaportBufferTbl: Record ImportBuffer;


    // LOCAL procedure UseExcelRowToUpdate(VAR ExcelBuffer: Record "Excel Buffer")
    // IF ExcelBuffer2.FINDSET THEN
    // REPEAT
    //     CASE ExcelBuffer2."Column No." OF
    //     1: CustomerNo := ExcelBuffer2."Cell Value as Text";
    //     2: CurrentLocationCode := ExcelBuffer2."Cell Value as Text";
    //     3: NewLocationCode := ExcelBuffer2."Cell Value as Text";
    //     END;
    // UNTIL ExcelBuffer2.NEXT = 0;

    // IF Customer.GET(CustomerNo) AND (Customer."Location Code" = CurrentLocationCode) THEN BEGIN
    // Customer."Location Code" := NewLocationCode;
    // Customer.MODIFY;
    // END;    
}
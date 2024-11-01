page 50104 Vendor
{
    PageType = Document;
    //ApplicationArea = All;
    //UsageCategory = Lists;
    SourceTable = VendorTbl;
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
                field(Name; Rec.Name)
                {
                    ApplicationArea = all;
                }
                field(Contact; Rec.Contact)
                {
                    ApplicationArea = all;
                }
                field("Balance (LCY)"; Rec."Balance (LCY)")
                {
                    ApplicationArea = all;
                }
                field("Balance Due (LCY)"; Rec."Balance Due (LCY)")
                {
                    ApplicationArea = all;
                }
                field("Payments (LCY)"; Rec."Payments (LCY)")
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
            action(Import)
            {
                ApplicationArea = All;
                Caption = 'Import', comment = 'NLB="YourLanguageCaption"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Import;
                ToolTip = 'Import Vendor Data From Excel';

                trigger OnAction()
                begin
                    ReadExcelSheet();
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
                ToolTip = 'Export To Excel Sheet';

                trigger OnAction()

                begin
                    //Message('Do You want to Export?');
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
        GSImportBuffer: Record VendorTbl;
        RowNo: Integer;
        ColNo: Integer;
        LineNo: Integer;
        MaxRow: Integer;
        DocNo: Code[24];
        Balance: Decimal;
        Payment: Decimal;
        Name: Text[50];
        Contact: Text[50];
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
            Evaluate(Name, GetValueAtCell(RowNo, 2));
            Evaluate(Contact, GetValueAtCell(RowNo, 3));
            Evaluate(Balance, GetValueAtCell(RowNo, 4));
            Evaluate(Payment, GetValueAtCell(RowNo, 6));
            //Evaluate(qty, GetValueAtCell(RowNo, 6));
            LineNo := LineNo + 10000;
            GSImportBuffer.SetRange("No.", DocNo);
            if not GSImportBuffer.Find('-') then begin
                GSImportBuffer.Init();
                // Evaluate(GSImportBuffer."Batch Name", BatchName);
                GSImportBuffer."No." := DocNo;
                Evaluate(GSImportBuffer."No.", GetValueAtCell(RowNo, 1));
                Evaluate(GSImportBuffer.Name, GetValueAtCell(RowNo, 2));
                Evaluate(GSImportBuffer.Contact, GetValueAtCell(RowNo, 3));
                Evaluate(GSImportBuffer."Balance (LCY)", GetValueAtCell(RowNo, 4));
                Evaluate(GSImportBuffer."Balance Due (LCY)", GetValueAtCell(RowNo, 5));
                Evaluate(GSImportBuffer."Payments (LCY)", GetValueAtCell(RowNo, 6));
                //GSImportBuffer."Sheet Name" := SheetName;
                //GSImportBuffer.Imported_Time := time;
                GSImportBuffer.Insert();
            end else begin//if it's existed
                GSImportBuffer.Validate(Name, Name);
                GSImportBuffer.Validate(Contact, Contact);
                GSImportBuffer.Validate("Balance (LCY)", Balance);
                GSImportBuffer.Validate("Payments (LCY)", Payment);

                GSImportBuffer.Modify();
            end;

        end;
        Message(ExcelImportSuccess);

    end;

    local procedure ExportExcel(var GSExcel: Record VendorTbl)
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        GSExcelLbl: Label 'GS Excel Vendor';
        GSFileName: Label 'GS Excel Vendor_%1_%2';
    begin
        TempExelBuffer.Reset();
        TempExelBuffer.DeleteAll();
        TempExelBuffer.NewRow();

        TempExelBuffer.AddColumn(GSExcel.FieldCaption("No."), false, '', false, false, false, '', TempExelBuffer."Cell Type"::Text);
        TempExelBuffer.AddColumn(GSExcel.FieldCaption(Name), false, '', false, false, false, '', TempExelBuffer."Cell Type"::Text);
        TempExelBuffer.AddColumn(GSExcel.FieldCaption(Contact), false, '', false, false, false, '', TempExelBuffer."Cell Type"::Text);
        TempExelBuffer.AddColumn(GSExcel.FieldCaption("Balance (LCY)"), false, '', false, false, false, '', TempExelBuffer."Cell Type"::Text);
        TempExelBuffer.AddColumn(GSExcel.FieldCaption("Balance Due (LCY)"), false, '', false, false, false, '', TempExelBuffer."Cell Type"::Text);
        TempExelBuffer.AddColumn(GSExcel.FieldCaption("Payments (LCY)"), false, '', false, false, false, '', TempExelBuffer."Cell Type"::Text);

        if GSExcel.FindSet() then
            repeat
                TempExelBuffer.NewRow();
                TempExelBuffer.AddColumn(GSExcel."No.", false, '', false, false, false, '', TempExelBuffer."Cell Type"::Text);
                TempExelBuffer.AddColumn(GSExcel.Name, false, '', false, false, false, '', TempExelBuffer."Cell Type"::Text);
                TempExelBuffer.AddColumn(GSExcel.Contact, false, '', false, false, false, '', TempExelBuffer."Cell Type"::Text);
                TempExelBuffer.AddColumn(GSExcel."Balance (LCY)", false, '', false, false, false, '', TempExelBuffer."Cell Type"::Text);
                TempExelBuffer.AddColumn(GSExcel."Balance Due (LCY)", false, '', false, false, false, '', TempExelBuffer."Cell Type"::Text);
                TempExelBuffer.AddColumn(GSExcel."Payments (LCY)", false, '', false, false, false, '', TempExelBuffer."Cell Type"::Text);
            until GSExcel.Next() = 0;

        TempExelBuffer.CreateNewBook(GSExcelLbl);
        TempExelBuffer.WriteSheet(GSExcelLbl, CompanyName, UserId);
        TempExelBuffer.CloseBook();
        TempExelBuffer.SetFriendlyFilename(StrSubstNo(GSFileName, CurrentDateTime, UserId));
        TempExelBuffer.OpenExcel();
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
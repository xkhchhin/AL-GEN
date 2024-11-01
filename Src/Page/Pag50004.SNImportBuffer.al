page 50112 SNImportBuffer
{
    Caption = 'SNImportBuffer()';
    PageType = ListPart;
    SourceTable = "Serial No. Information";
    SourceTableTemporary = true;
    DelayedInsert = true;
    //InsertAllowed = false;
    //ModifyAllowed = false;
    SaveValues = true;
    AutoSplitKey = true;




    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number that is copied from the Tracking Specification table, when a serial number information record is created.';
                }
                field("Serial No."; Rec."Serial No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies this number from the Tracking Specification table when a serial number information record is created.';
                }
                field("Variant Code"; Rec."Variant Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of the serial no. information record.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of the serial no. information record.';
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies that the related record is blocked from being posted in transactions, for example a customer that is declared insolvent or an item that is placed in quarantine.';
                }
                // field("Request / Reference No."; Rec."Request / Reference No.")
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the value of the Request / Reference No. field.';
                // }
                // field("Reference Link"; Rec."Reference Link")
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the value of the Reference Link field.';
                // }
                // field(Imported; Rec.Imported)
                // {
                //     ApplicationArea = All;
                // }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Import)
            {
                ApplicationArea = All;
                Caption = 'Import', comment = '="YourLanguageCaption"';
                // Promoted = true;
                // PromotedCategory = Process;
                // PromotedIsBig = true;
                Image = ImportExcel;

                trigger OnAction()
                begin
                    ReadExcelSerialNoInfo();
                end;
            }
        }
    }
    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    begin
        TempExelBuffer.Reset();
        if TempExelBuffer.get(RowNo, ColNo) then
            exit(TempExelBuffer."Cell Value as Text")
        else
            exit('');
    end;

    local procedure ReadExcelSerialNoInfo()
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
        ImportExcelDataSerialNoInfo();
    end;

    local procedure ImportExcelDataSerialNoInfo()
    var
        SerialNoInfoImportBuffer: Record "Serial No. Information";
        RowNo: Integer;
        ColNo: Integer;
        ItemNo: code[20];
        Description: Text[100];
        SerialNo: Code[50];
        VariantCode: Code[10];
        LineNo: Integer;
        MaxRowNo: Integer;
        Progress: Dialog;
        RecordCounted: Integer;
        Counter: Integer;
        ProgressMsg: Label 'Serial No. Information Importing\Invoice No.: #1#####\Record Count: #2#####\Total Records Counted: #3#####';

    begin
        RowNo := 0;
        ColNo := 0;
        MaxRowNo := 0;
        LineNo := 0;
        SerialNoInfoImportBuffer.Reset();
        TempExelBuffer.Reset();
        if TempExelBuffer.FindLast() then begin
            MaxRowNo := TempExelBuffer."Row No.";
        end;
        if TempExelBuffer.FindSet() then
            RecordCounted := TempExelBuffer.Count;
        Progress.OPEN(ProgressMsg, SerialNoInfoImportBuffer."Item No.", Counter, RecordCounted);//progress dialog open
        for RowNo := 2 to MaxRowNo do begin

            //Evaluate(SerialNo, GetValueAtCell(RowNo,2));
            Evaluate(VariantCode, GetValueAtCell(RowNo, 3));
            Evaluate(Description, GetValueAtCell(RowNo, 4));

            Counter := Counter + 1;//update dialog
            LineNo := LineNo + 10000;
            SerialNoInfoImportBuffer.SetRange("Item No.", ItemNo);
            if not SerialNoInfoImportBuffer.Find('-') then begin
                SerialNoInfoImportBuffer.Init();
                SerialNoInfoImportBuffer."Item No." := ItemNo;
                Evaluate(SerialNoInfoImportBuffer."Item No.", GetValueAtCell(RowNo, 1));
                Evaluate(SerialNoInfoImportBuffer."Serial No.", GetValueAtCell(RowNo, 2));
                Evaluate(SerialNoInfoImportBuffer."Variant Code", GetValueAtCell(RowNo, 3));
                Evaluate(SerialNoInfoImportBuffer.Description, GetValueAtCell(RowNo, 4));
                SerialNoInfoImportBuffer.Insert();

            end else begin
                //Modify
                //SerialNoInfoImportBuffer.validate("Serial No.", SerialNo);
                SerialNoInfoImportBuffer.validate(Description, Description);

                SerialNoInfoImportBuffer.Modify(true);
                Progress.UPDATE(); // Update the field in the dialog. 
            end;
        end;
        Progress.CLOSE();
        Message('Total Serial No. Information Imported = %1', Counter);
    end;

    var
        myInt: Integer;
        ImportMess: Label 'Import Action';
        ExportMess: Label 'Export Action';
        FileName: Text[100];
        SheetName: Text[100];
        TempExelBuffer: Record "Excel Buffer" temporary;
        UploadMsg: Label 'Please Choose The Excel File';
        NoFileMsg: Label 'No Excel File Found';
        ExcelImportSuccess: Label 'Excel Import Success';
        ImaportBufferSerialNoInfoTbl: Record "Serial No. Information";
        DeleteSerialNoInfoMss: Label 'Serial No. Information Record Has Been Deleted.';
        ExcelSerialNoInfoImportSucess: Label 'Serial No. Information with document is successfully imported.';
        SerialNoInfo: Label 'Serial No. Information';
}

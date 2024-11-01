tableextension 50105 "Inc. Doc. Attachment Overview" extends "Inc. Doc. Attachment Overview"
{
    [IntegrationEvent(false, false)]
    local procedure OnBeforeSaveAttachment(var IncDocumentAttachment: Record "Inc. Doc. Attachment Overview"; var TempBlob: Codeunit "Temp Blob")
    begin
    end;
}

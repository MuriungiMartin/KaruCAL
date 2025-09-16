#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1629 "Office Attachment Manager"
{
    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    var
        UrlString: Text;
        NameString: Text;
        Body: Text;
        "Count": Integer;


    procedure Add(FileUrl: Text;FileName: Text;BodyText: Text)
    begin
        if UrlString <> '' then begin
          UrlString += '|';
          NameString += '|';
        end;
        UrlString += FileUrl;
        NameString += FileName;
        if Body = '' then
          Body := BodyText;
        Count -= 1;
    end;


    procedure Ready(): Boolean
    begin
        exit(Count < 1);
    end;


    procedure Done()
    begin
        Count := 0;
        UrlString := '';
        NameString := '';
        Body := '';
    end;


    procedure GetUrl(): Text
    begin
        exit(UrlString);
    end;


    procedure GetName(): Text
    begin
        exit(NameString);
    end;


    procedure GetBody(): Text
    var
        MailMgt: Codeunit "Mail Management";
    begin
        exit(MailMgt.ImageBase64ToUrl(Body));
    end;


    procedure IncrementCount(NewCount: Integer)
    begin
        Count += NewCount;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnSendSalesDocument', '', false, false)]
    local procedure OnSendSalesDocument(ShipAndInvoice: Boolean)
    begin
        if ShipAndInvoice then
          Count := 2;
    end;
}


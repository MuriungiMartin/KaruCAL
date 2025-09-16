#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 780 "Certificates of Supply"
{
    ApplicationArea = Basic;
    Caption = 'Certificates of Supply';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Certificate of Supply";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the type of the posted document to which the certificate of supply applies.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the document number of the posted shipment document associated with the certificate of supply.';
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the status for documents where you must receive a signed certificate of supply from the customer.';
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the certificate.';
                }
                field("Receipt Date";"Receipt Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the receipt date of the signed certificate of supply.';
                }
                field(Printed;Printed)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies whether the certificate of supply has been printed and sent to the customer.';
                }
                field("Customer/Vendor Name";"Customer/Vendor Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the customer or vendor.';
                }
                field("Shipment Date";"Shipment/Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date that the posted shipment was shipped or posted.';
                }
                field("Shipment Country";"Ship-to Country/Region Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the country/region code of the address.';
                }
                field("Customer/Vendor No.";"Customer/Vendor No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the number of the customer or vendor.';
                }
                field("Shipment Method";"Shipment Method Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the shipment method. The code is copied from the posted shipment document.';
                }
                field("Vehicle Registration No.";"Vehicle Registration No.")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(PrintCertificateofSupply)
            {
                ApplicationArea = Basic;
                Caption = 'Print Certificate of Supply';
                Image = PrintReport;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    CertificateOfSupply: Record "Certificate of Supply";
                begin
                    if not IsEmpty then begin
                      CertificateOfSupply.Copy(Rec);
                      CertificateOfSupply.SetRange("Document Type","Document Type");
                      CertificateOfSupply.SetRange("Document No.","Document No.");
                    end;
                    CertificateOfSupply.Print;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if GetFilters = '' then
          SetFilter(Status,'<>%1',Status::"Not Applicable")
        else
          InitRecord("Document Type","Document No.")
    end;
}


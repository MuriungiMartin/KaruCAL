#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68794 "ACA-Proforma"
{
    PageType = Document;
    SourceTable = UnknownTable61588;
    SourceTableView = where("Proforma No."=filter(<>9999999999));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Proforma No.";"Proforma No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                }
                field(Address;Address)
                {
                    ApplicationArea = Basic;
                }
                field("Address 2";"Address 2")
                {
                    ApplicationArea = Basic;
                }
                field("Post Code";"Post Code")
                {
                    ApplicationArea = Basic;
                }
                field(City;City)
                {
                    ApplicationArea = Basic;
                }
                field(County;County)
                {
                    ApplicationArea = Basic;
                }
                field(Contact;Contact)
                {
                    ApplicationArea = Basic;
                }
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = Basic;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                }
                field(Programme;Programme)
                {
                    ApplicationArea = Basic;
                }
                field("Programme Description";"Programme Description")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Register for";"Register for")
                {
                    ApplicationArea = Basic;
                }
                field(Stage;Stage)
                {
                    ApplicationArea = Basic;
                }
                field(Unit;Unit)
                {
                    ApplicationArea = Basic;
                }
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
                }
                field("Student Type";"Student Type")
                {
                    ApplicationArea = Basic;
                }
                field(Modules;Modules)
                {
                    ApplicationArea = Basic;
                }
                field("Settlement Type";"Settlement Type")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control1102760010;"ACA-Proforma Lines")
            {
                SubPageLink = "Reg. Transacton ID"=field("Proforma No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Print Proforma")
            {
                ApplicationArea = Basic;
                Caption = 'Print Proforma';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Proforma.Reset;
                    Proforma.SetRange(Proforma."Proforma No.","Proforma No.");
                    if Proforma.Find('-') then
                    Report.Run(39005978,true,false,Proforma);
                end;
            }
        }
    }

    var
        Proforma: Record UnknownRecord61588;
}


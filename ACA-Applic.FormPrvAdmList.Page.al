#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68490 "ACA-Applic. Form Prv Adm List"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Document;
    SourceTable = UnknownTable61358;
    SourceTableView = where(Status=const("Provisional Admission"));

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(Select;Select)
                {
                    ApplicationArea = Basic;
                }
                field("Application No.";"Application No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Application Date";"Application Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Admitted Degree";"Admitted Degree")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Admitted To Stage";"Admitted To Stage")
                {
                    ApplicationArea = Basic;
                }
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Admitted Semester";"Admitted Semester")
                {
                    ApplicationArea = Basic;
                }
                field("Settlement Type";"Settlement Type")
                {
                    ApplicationArea = Basic;
                }
                field("Date Of Meeting";"Date Of Meeting")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Deferred Until";"Deferred Until")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Surname;Surname)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Other Names";"Other Names")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Date Of Birth";"Date Of Birth")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Marital Status";"Marital Status")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Nationality;Nationality)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Country of Origin";"Country of Origin")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Functions")
            {
                Caption = '&Functions';
                action("&Print Admission Letter & Fee Structure")
                {
                    ApplicationArea = Basic;
                    Caption = '&Print Admission Letter & Fee Structure';
                    Image = Print;
                    Promoted = true;

                    trigger OnAction()
                    begin
                        /*Ask the user for the confirmation to  send o the printer*/
                        SendToPrinter:=true;
                        if Confirm('Send Selected Provisional Admission Letter DIRECTLY to Printer',false)=false then
                          begin
                            SendToPrinter:=false;
                          end;
                        /*Set the range for the printer*/
                        Apps.Reset;
                        Apps.SetRange(Apps."Application No.","Application No.");
                        Apps.SetRange(Apps.Select,true);
                        if Apps.Find('-') then
                          begin
                           repeat
                            /*Print the report for the selected provisional admission letter*/
                            if SendToPrinter=true then
                              begin
                                Report.Run(39005743,false,SendToPrinter,Apps);
                             //  REPORT.RUN(39005761,FALSE,SendToPrinter,Apps);
                              end
                            else
                              begin
                                Report.Run(39005743,true,SendToPrinter,Apps);
                              //  REPORT.RUN(39005743,TRUE,SendToPrinter,Apps);
                              //  REPORT.RUN(39005761,TRUE,SendToPrinter,Apps);
                              end;
                            until Apps.Next=0;
                          end;

                    end;
                }
            }
        }
    }

    var
        Apps: Record UnknownRecord61358;
        SendToPrinter: Boolean;
}


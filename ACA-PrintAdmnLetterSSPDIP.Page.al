#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68524 "ACA-Print Admn Letter SSP/DIP"
{
    DeleteAllowed = false;
    PageType = List;
    SourceTable = UnknownTable61358;
    SourceTableView = where("Settlement Type"=filter(PSSP));

    layout
    {
        area(content)
        {
            repeater(Control18)
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
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("First Degree Choice";"First Degree Choice")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("First Choice Stage";"First Choice Stage")
                {
                    ApplicationArea = Basic;
                }
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("First Choice Semester";"First Choice Semester")
                {
                    ApplicationArea = Basic;
                }
                field("Settlement Type";"Settlement Type")
                {
                    ApplicationArea = Basic;
                }
                field(Salutation;Salutation)
                {
                    ApplicationArea = Basic;
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
                field("Address 1";Apps."Address for Correspondence1")
                {
                    ApplicationArea = Basic;
                }
                field("Address 2";Apps."Address for Correspondence2")
                {
                    ApplicationArea = Basic;
                }
                field(Phone;Apps."Telephone No. 1")
                {
                    ApplicationArea = Basic;
                }
                field("Address for Correspondence1";"Address for Correspondence1")
                {
                    ApplicationArea = Basic;
                    Caption = 'Postal Address';
                }
                field("Address for Correspondence2";"Address for Correspondence2")
                {
                    ApplicationArea = Basic;
                    Caption = 'Postal Code';
                }
                field("Address for Correspondence3";"Address for Correspondence3")
                {
                    ApplicationArea = Basic;
                    Caption = 'Town';
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
                        TestField("First Degree Choice");
                        if "First Degree Choice"<>'' then begin
                          if progs.Get("First Degree Choice") then begin
                          end;
                        
                        end;
                        Apps.Reset;
                        Apps.SetRange(Apps."Application No.","Application No.");
                        Apps.SetRange(Apps.Select,true);
                        if Apps.Find('-') then
                          begin
                           repeat
                            /*Print the report for the selected provisional admission letter*/
                            if SendToPrinter=true then
                              begin
                               if ((progs.Category<>progs.Category::Diploma) and (progs.Category<>progs.Category::"Certificate ")) then
                                Report.Run(51339,false,SendToPrinter,Apps)
                                else
                                Report.Run(51339,false,SendToPrinter,Apps);
                              end
                            else
                              begin
                              if ((progs.Category<>progs.Category::Diploma) and (progs.Category<>progs.Category::"Certificate ")) then
                                Report.Run(51339,true,SendToPrinter,Apps)
                                else
                                Report.Run(51339,true,SendToPrinter,Apps);
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
        progs: Record UnknownRecord61511;
}


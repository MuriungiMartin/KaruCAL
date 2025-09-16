#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68512 "ACA-Print Admission Letters"
{
    PageType = List;
    SourceTable = UnknownTable61372;
    SourceTableView = where("Admission Type"=const(JAB));

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                Editable = true;
                field(Select;Select)
                {
                    ApplicationArea = Basic;
                }
                field("Admission No.";"Admission No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Admission Type";"Admission Type")
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
                field("Faculty Admitted To";"Faculty Admitted To")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Degree Admitted To";"Degree Admitted To")
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
                field("E-Mail";"E-Mail")
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
            action("&Print Admission Letters and Fee Structures")
            {
                ApplicationArea = Basic;
                Caption = '&Print Admission Letters and Fee Structures';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    /*Ask for the user confirmation*/
                    if Confirm('Print out Admissions Letters and Fee Structure for Selected Admissions?',true)=false then begin exit end;
                    
                    PrintToPrinter:=false;
                    /*Ask for conformation of send to printer*/
                    if Confirm('Send Letters Directly to System Default Printer?',false)=true then
                      begin
                        PrintToPrinter:=true;
                      end;
                    Admissions.Reset;
                    Admissions.SetRange(Admissions."Admission Type",'JAB');
                    Admissions.SetRange(Admissions.Select,true);
                    
                    /*Check if the record has been retrieved*/
                    if Admissions.Find('-') then
                      begin
                        repeat
                          ReportAdm.Reset;
                          ReportAdm.SetRange(ReportAdm."Admission No.",Admissions."Admission No.");
                              if PrintToPrinter=true then
                                begin
                                //  REPORT.RUN(39005742,FALSE,FALSE,ReportAdm);
                                //  REPORT.RUN(39005761,FALSE,FALSE,ReportAdm);
                                end
                              else
                                begin
                                  Report.Run(39005742,true,true,ReportAdm);
                                 //  REPORT.RUN(39005761,FALSE,FALSE,ReportAdm);
                                end;
                        until Admissions.Next=0;
                      end;

                end;
            }
        }
    }

    var
        Admissions: Record UnknownRecord61372;
        PrintToPrinter: Boolean;
        ReportAdm: Record UnknownRecord61372;
}


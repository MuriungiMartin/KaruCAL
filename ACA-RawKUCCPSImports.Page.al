#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 62200 "ACA-Raw KUCCPS Imports"
{
    PageType = List;
    SourceTable = UnknownTable62200;
    SourceTableView = where(Posted=filter(No));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Applicant;Applicant)
                {
                    ApplicationArea = Basic;
                }
                field("A.id";"A.id")
                {
                    ApplicationArea = Basic;
                }
                field("Fee Type";"Fee Type")
                {
                    ApplicationArea = Basic;
                }
                field(Email;Email)
                {
                    ApplicationArea = Basic;
                }
                field(Cell;Cell)
                {
                    ApplicationArea = Basic;
                }
                field("P.id";"P.id")
                {
                    ApplicationArea = Basic;
                }
                field("Kuccps.id";"Kuccps.id")
                {
                    ApplicationArea = Basic;
                }
                field(Stream;Stream)
                {
                    ApplicationArea = Basic;
                }
                field(Faculty;Faculty)
                {
                    ApplicationArea = Basic;
                }
                field(Intake;Intake)
                {
                    ApplicationArea = Basic;
                }
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                }
                field("Admision No.";"Admision No.")
                {
                    ApplicationArea = Basic;
                }
                field("Serial No.";"Serial No.")
                {
                    ApplicationArea = Basic;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                }
                field("Reporting Date";"Reporting Date")
                {
                    ApplicationArea = Basic;
                }
                field(Posted;Posted)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Failure Reason";"Failure Reason")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(process_to_Kuccps)
            {
                ApplicationArea = Basic;
                Caption = 'Post To KUCCPS Data';
                Image = Production;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    countedRecs: Integer;
                begin
                    if Confirm('Generate KUCCPS data?',true)=false then Error('Cancelled by '+UserId);

                    currrecs.Reset;
                    currrecs.SetRange(currrecs.Posted,false);
                    if currrecs.Find('-') then begin
                      repeat
                          begin
                          applications.Reset;
                          applications.SetRange(applications."K.C.S.E Index Number",currrecs."A.id");
                          if not applications.Find('-') then begin
                              // INSERT RECORDS HERE
                            Clear(countedRecs);
                            applications.Reset;
                            if applications.Find('-') then begin countedRecs:=applications.Count; end;
                            if not ((getProgCode(currrecs."P.id"))='') then begin
                            applications.Init;
                          applications."K.C.S.E Index Number":=currrecs."A.id";
                    applications."Line No.":=countedRecs+1;
                    applications."Degree Code":=getProgCode(currrecs."P.id");
                    applications."S.No":=countedRecs+1;
                    applications."Candidates Name":=currrecs.Applicant;
                    applications.Gender:=currrecs.Gender;
                    applications."Admission No.":=currrecs."Admision No.";
                    applications."Mobile No":=currrecs.Cell;
                    applications."P.O Box":=currrecs.Email;
                    applications."Reporting Date":=currrecs."Reporting Date";
                    applications.Insert;
                      currrecs."Failure Reason":='';
                      currrecs.Posted:=true;
                      currrecs.Modify;
                    end else begin
                      currrecs."Failure Reason":='Missing Prog. Code';
                      currrecs.Modify;
                      end;
                            end;
                    end;
                        until currrecs.Next =0;
                      end;
                     Report.Run(51348,true,true);
                end;
            }
        }
    }

    var
        currrecs: Record UnknownRecord62200;
        applications: Record UnknownRecord61369;
        prog: Record UnknownRecord61511;

    local procedure getProgCode(var progCode1: Code[20]) progcode2: Code[20]
    begin
        if prog.Get(progCode1) then progcode2:=prog.Code else begin
            prog.Reset;
          prog.SetRange("Old Code",progCode1);
          if prog.Find('-') then begin
            progcode2:=prog.Code;
            end else progcode2:='';// ELSE ERROR('The specified program is not in the list of programs. Neither as Old Nor as new code.');
          end;
    end;
}


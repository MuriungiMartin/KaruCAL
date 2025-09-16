#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68874 "HRM-Shortlisting Card"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Shortlist';
    SourceTable = UnknownTable61200;
    SourceTableView = where(Status=const(Approved),
                            Closed=const(No));

    layout
    {
        area(content)
        {
            group(ToggletheView)
            {
                Caption = 'Toggle View';
                Editable = true;
                field(FilterView;toggleView)
                {
                    ApplicationArea = Basic;
                    Caption = 'FilterView';
                    Editable = true;

                    trigger OnValidate()
                    begin
                        if toggleView = Toggleview::Both then begin
                            ViewQualified := true;
                            ViewUnqualified := true;
                          end else if toggleView = Toggleview::Qualified then begin
                            ViewQualified := true;
                            ViewUnqualified := false;
                          end else if toggleView = Toggleview::Unqualified then begin
                            ViewQualified := false;
                            ViewUnqualified := true;
                          end;
                    end;
                }
            }
            group("Job Details")
            {
                Caption = 'Job Details';
                Editable = true;
                field("Job ID";"Job ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                    Importance = Promoted;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
                field("Job Description";"Job Description")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                    Importance = Promoted;
                }
                field("Requisition Date";"Requisition Date")
                {
                    ApplicationArea = Basic;
                    Editable = "Requisition DateEditable";
                    Enabled = false;
                    Importance = Promoted;
                }
                field(Priority;Priority)
                {
                    ApplicationArea = Basic;
                    Editable = PriorityEditable;
                    Enabled = false;
                    Importance = Promoted;
                }
                field("Vacant Positions";"Vacant Positions")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                    Importance = Promoted;
                }
                field("Required Positions";"Required Positions")
                {
                    ApplicationArea = Basic;
                    Editable = "Required PositionsEditable";
                    Enabled = false;
                    Importance = Promoted;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                    Importance = Promoted;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
            }
            group(QualifiedApplicants)
            {
                Caption = 'Qualified Applicants';
                Editable = true;
                Visible = ViewQualified;
                part(Shortlisted;"HRM-Job Applications List")
                {
                    Editable = ShortlistedEditable;
                    SubPageLink = "Employee Requisition No"=field("Requisition No."),
                                  "Not Qualified (System)"=filter(false);
                }
            }
            group(UnqualifiedApplicants)
            {
                Caption = 'Unqualified Applicants';
                Editable = true;
                Visible = ViewUnqualified;
                part(Control1000000001;"HRM-Job Applications List")
                {
                    SubPageLink = "Employee Requisition No"=field("Requisition No."),
                                  "Not Qualified (System)"=filter(true);
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Applicants)
            {
                Caption = 'Applicants';
                action("&ShortList Applicants By Job Requirements")
                {
                    ApplicationArea = Basic;
                    Caption = '&ShortList Applicants By Job Requirements';
                    Image = SelectField;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = false;

                    trigger OnAction()
                    begin
                        /*HRJobRequirements.RESET;
                        HRJobRequirements.SETRANGE(HRJobRequirements."Job Id","Job ID");
                        IF HRJobRequirements.COUNT=0 THEN BEGIN
                        MESSAGE('Job Requirements for the job '+ "Job ID" +' have not been setup');
                        EXIT;
                        END ELSE BEGIN
                        
                        //GET JOB REQUIREMENTS
                        HRJobRequirements.RESET;
                        HRJobRequirements.SETRANGE(HRJobRequirements."Job Id","Job ID");
                        
                        //DELETE ALL RECORDS FROM THE SHORTLISTED APPLICANTS TABLE
                        HRShortlistedApplicants.RESET;
                        HRShortlistedApplicants.SETRANGE(HRShortlistedApplicants."Employee Requisition No","Requisition No.");
                        HRShortlistedApplicants.DELETEALL;
                        
                        //GET JOB APPLICANTS
                        HRJobApplications.RESET;
                        HRJobApplications.SETRANGE(HRJobApplications."Employee Requisition No","Requisition No.");
                        IF HRJobApplications.FIND('-') THEN BEGIN
                        REPEAT
                              Qualified:= TRUE;
                              IF HRJobRequirements.FIND('-') THEN BEGIN
                              StageScore:=0;
                              Score:=0;
                              REPEAT
                              //GET THE APPLICANTS QUALIFICATIONS AND COMPARE THEM WITH THE JOB REQUIREMENTS
                              AppQualifications.RESET;
                              AppQualifications.SETRANGE(AppQualifications."Application No",HRJobApplications."Application No");
                              AppQualifications.SETRANGE(AppQualifications."Qualification Code",HRJobRequirements."Qualification Code");
                              IF AppQualifications.FIND('-') THEN BEGIN
                                Score:=Score + AppQualifications."Score ID";
                                IF AppQualifications."Score ID" < HRJobRequirements."Desired Score" THEN
                                    Qualified:= FALSE;
                              END ELSE BEGIN
                                Qualified:= FALSE;
                              END;
                        
                              UNTIL HRJobRequirements.NEXT = 0;
                        END;
                        
                        HRShortlistedApplicants."Employee Requisition No":="Requisition No.";
                        HRShortlistedApplicants."Job Application No":=HRJobApplications."Application No";
                        HRShortlistedApplicants."Stage Score":=Score;
                        HRShortlistedApplicants.Qualified:=Qualified;
                        HRShortlistedApplicants."First Name":=HRJobApplications."First Name";
                        HRShortlistedApplicants."Middle Name":=HRJobApplications."Middle Name";
                        HRShortlistedApplicants."Last Name":=HRJobApplications."Last Name";
                        HRShortlistedApplicants."ID No":=HRJobApplications."ID Number";
                        HRShortlistedApplicants.Gender:=HRJobApplications.Gender;
                        HRShortlistedApplicants."Marital Status":=HRJobApplications."Marital Status";
                        HRShortlistedApplicants.INSERT;
                        
                        UNTIL HRJobApplications.NEXT = 0;
                        END;
                        //MARK QUALIFIED APPLICANTS AS QUALIFIED
                        HRShortlistedApplicants.SETRANGE(HRShortlistedApplicants.Qualified,TRUE);
                        IF HRShortlistedApplicants.FIND('-') THEN
                        REPEAT
                          HRJobApplications.GET(HRShortlistedApplicants."Job Application No");
                          HRJobApplications.Qualified:=TRUE;
                          HRJobApplications.MODIFY;
                        UNTIL HRShortlistedApplicants.NEXT=0;
                        {
                        RecCount:= 0;
                        MyCount:=0;
                        StageShortlist.RESET;
                        StageShortlist.SETRANGE(StageShortlist."Need Code","Need Code");
                        StageShortlist.SETRANGE(StageShortlist."Stage Code","Stage Code");
                        
                        IF StageShortlist.FIND('-') THEN BEGIN
                        RecCount:=StageShortlist.COUNT ;
                        StageShortlist.SETCURRENTKEY(StageShortlist."Stage Score");
                        StageShortlist.ASCENDING;
                        REPEAT
                        MyCount:=MyCount + 1;
                        StageShortlist.Position:=RecCount - MyCount;
                        StageShortlist.MODIFY;
                        UNTIL StageShortlist.NEXT = 0;
                        END;
                        }
                        MESSAGE('%1','Shortlisting Competed Successfully.');
                        
                        END; */
                        //END ELSE
                        //MESSAGE('%1','You must select the stage you would like to shortlist.');

                    end;
                }
                action("&Print")
                {
                    ApplicationArea = Basic;
                    Caption = '&Print';
                    Image = PrintReport;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        HREmpReq.Reset;
                        HREmpReq.SetRange(HREmpReq."Requisition No.","Requisition No.");
                        if HREmpReq.Find('-') then
                        Report.Run(39005576,true,true,HREmpReq);
                    end;
                }
                action(ShortListByCriteria)
                {
                    ApplicationArea = Basic;
                    Caption = '&ShortList Applicants By Criteria';
                    Image = SelectField;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    var
                        TotalAttainedMarks: Decimal;
                        HRMApplicantJobQualification: Record UnknownRecord60228;
                        JobApplicQualifications: Record UnknownRecord60238;
                        HRMJobApplicationsB: Record UnknownRecord61225;
                        TotalAttainableMarks: Decimal;
                    begin
                        if Confirm('Run shortlisting?',true)=false then Error('Cancelled by user!');
                        Clear(HRJobApplications);
                        HRJobApplications.Reset;
                        HRJobApplications.SetRange("Employee Requisition No",Rec."Requisition No.");
                        if HRJobApplications.Find('-') then begin
                          repeat
                            begin
                              Clear(HRMApplicantJobQualification);
                              HRMApplicantJobQualification.Reset;
                              HRMApplicantJobQualification.SetRange(Application_No,HRJobApplications."Application No");
                              if HRMApplicantJobQualification.Find('-') then begin
                                repeat
                                  begin
                                  Clear(TotalAttainedMarks);
                                  Clear(TotalAttainableMarks);
                                    Clear(JobApplicQualifications);
                                    JobApplicQualifications.Reset;
                                    JobApplicQualifications.SetRange(Application_Id,HRMApplicantJobQualification.Application_No);
                                    JobApplicQualifications.SetRange("Criteria Code",HRMApplicantJobQualification.Code);
                                    if JobApplicQualifications.Find('-') then begin
                                      repeat
                                        begin
                                        if JobApplicQualifications."Attachment Exists" = true then
                                        TotalAttainedMarks += JobApplicQualifications."Achievable Score";
                                        TotalAttainableMarks += JobApplicQualifications."Achievable Score";
                                        end;
                                        until JobApplicQualifications.Next = 0;
                                      end;
                                    HRMApplicantJobQualification."Total Score" :=0;
                                    HRMApplicantJobQualification."Average Score" :=0;
                                    HRMApplicantJobQualification.Pass := false;
                                    if ((TotalAttainableMarks> 0) and (TotalAttainedMarks >0)) then begin
                                    HRMApplicantJobQualification."Total Score" :=TotalAttainedMarks;
                                    HRMApplicantJobQualification."Average Score" :=(TotalAttainedMarks/TotalAttainableMarks)*HRMApplicantJobQualification.Weight;
                                    HRMApplicantJobQualification."Average Score" := ROUND(HRMApplicantJobQualification."Average Score",0.01,'=');
                                    if HRMApplicantJobQualification."Average Score" < HRMApplicantJobQualification."Minimum Score"  then begin
                                      HRMApplicantJobQualification.Pass := false;
                                      end else begin
                                      HRMApplicantJobQualification.Pass := true;
                                        end;
                                      end;
                                      HRMApplicantJobQualification.Modify;
                                  end;
                                  until HRMApplicantJobQualification.Next = 0;
                                end;
                            end;
                            until HRJobApplications.Next = 0;
                          end;
                        
                        Message('%1','Shortlisting Competed Successfully.');
                        // "HRJobShortList Criteria".RESET;
                        // "HRJobShortList Criteria".SETRANGE("HRJobShortList Criteria"."Job Id","Job ID");
                        // IF "HRJobShortList Criteria".COUNT=0 THEN BEGIN
                        // MESSAGE('Job Requirements for the job '+ "Job ID" +' have not been setup');
                        // EXIT;
                        // END ELSE BEGIN
                        /*
                        //GET JOB REQUIREMENTS
                        "HRJobShortList Criteria".RESET;
                        "HRJobShortList Criteria".SETRANGE("HRJobShortList Criteria"."Job Id","Job ID");
                        
                        //DELETE ALL RECORDS FROM THE SHORTLISTED APPLICANTS TABLE
                        HRShortlistedApplicants.RESET;
                        HRShortlistedApplicants.SETRANGE(HRShortlistedApplicants."Employee Requisition No","Requisition No.");
                        HRShortlistedApplicants.DELETEALL;
                        
                        
                        //GET JOB APPLICANTS
                        HRJobApplications.RESET;
                        HRJobApplications.SETRANGE(HRJobApplications."Employee Requisition No","Requisition No.");
                        IF HRJobApplications.FIND('-') THEN BEGIN
                        REPEAT
                              Qualified:= TRUE;
                              IF HRJobRequirements.FIND('-') THEN BEGIN
                              StageScore:=0;
                              Score:=0;
                              REPEAT
                              //GET THE APPLICANTS QUALIFICATIONS AND COMPARE THEM WITH THE JOB REQUIREMENTS
                              AppQualifications.RESET;
                              AppQualifications.SETRANGE(AppQualifications."Application No",HRJobApplications."Application No");
                              AppQualifications.SETRANGE(AppQualifications."Qualification Code","HRJobShortList Criteria"."ShortList Code");
                              IF AppQualifications.FIND('-') THEN BEGIN
                                Score:=Score + AppQualifications."Score ID";
                                IF AppQualifications."Score ID" < "HRJobShortList Criteria"."Desired Score" THEN
                                    Qualified:= FALSE;
                              END ELSE BEGIN
                                Qualified:= FALSE;
                              END;
                        
                              UNTIL "HRJobShortList Criteria".NEXT = 0;
                        END;
                        
                        HRShortlistedApplicants."Employee Requisition No":="Requisition No.";
                        HRShortlistedApplicants."Job Application No":=HRJobApplications."Application No";
                        HRShortlistedApplicants."Stage Score":=Score;
                        HRShortlistedApplicants.Qualified:=Qualified;
                        HRShortlistedApplicants."First Name":=HRJobApplications."First Name";
                        HRShortlistedApplicants."Middle Name":=HRJobApplications."Middle Name";
                        HRShortlistedApplicants."Last Name":=HRJobApplications."Last Name";
                        HRShortlistedApplicants."ID No":=HRJobApplications."ID Number";
                        HRShortlistedApplicants.Gender:=HRJobApplications.Gender;
                        HRShortlistedApplicants."Marital Status":=HRJobApplications."Marital Status";
                        HRShortlistedApplicants.INSERT;
                        
                        UNTIL HRJobApplications.NEXT = 0;
                        END;
                        //MARK QUALIFIED APPLICANTS AS QUALIFIED
                        HRShortlistedApplicants.SETRANGE(HRShortlistedApplicants.Qualified,TRUE);
                        IF HRShortlistedApplicants.FIND('-') THEN
                        REPEAT
                          HRJobApplications.GET(HRShortlistedApplicants."Job Application No");
                          HRJobApplications.Qualified:=TRUE;
                          HRJobApplications.MODIFY;
                        UNTIL HRShortlistedApplicants.NEXT=0;
                        {
                        RecCount:= 0;
                        MyCount:=0;
                        StageShortlist.RESET;
                        StageShortlist.SETRANGE(StageShortlist."Need Code","Need Code");
                        StageShortlist.SETRANGE(StageShortlist."Stage Code","Stage Code");
                        
                        IF StageShortlist.FIND('-') THEN BEGIN
                        RecCount:=StageShortlist.COUNT ;
                        StageShortlist.SETCURRENTKEY(StageShortlist."Stage Score");
                        StageShortlist.ASCENDING;
                        REPEAT
                        MyCount:=MyCount + 1;
                        StageShortlist.Position:=RecCount - MyCount;
                        StageShortlist.MODIFY;
                        UNTIL StageShortlist.NEXT = 0;
                        END;
                        }
                        */
                        
                        //END;
                        //END ELSE
                        //MESSAGE('%1','You must select the stage you would like to shortlist.');
                        CurrPage.Update;

                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnInit()
    begin
        "Required PositionsEditable" := true;
        PriorityEditable := true;
        ShortlistedEditable := true;
        "Requisition DateEditable" := true;
        "Job IDEditable" := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    begin
        ViewQualified := false;
        ViewUnqualified := false;
    end;

    var
        HRJobRequirements: Record UnknownRecord61195;
        AppQualifications: Record UnknownRecord61226;
        HRJobApplications: Record UnknownRecord61225;
        Qualified: Boolean;
        StageScore: Decimal;
        HRShortlistedApplicants: Record UnknownRecord61227;
        MyCount: Integer;
        RecCount: Integer;
        HREmpReq: Record UnknownRecord61200;
        [InDataSet]
        "Job IDEditable": Boolean;
        [InDataSet]
        "Requisition DateEditable": Boolean;
        [InDataSet]
        ShortlistedEditable: Boolean;
        [InDataSet]
        PriorityEditable: Boolean;
        [InDataSet]
        "Required PositionsEditable": Boolean;
        Text19057439: label 'Short Listed Candidates';
        "HRJobShortList Criteria": Record UnknownRecord61210;
        "Applicant Criteria Score": Text;
        toggleView: Option " ",Both,Qualified,Unqualified;
        ViewQualified: Boolean;
        ViewUnqualified: Boolean;


    procedure UpdateControls()
    begin

        if Status=Status::New then begin
        "Job IDEditable" :=true;
        "Requisition DateEditable" :=true;
        ShortlistedEditable :=true;
        PriorityEditable :=true;
        "Required PositionsEditable" :=true;
        end else begin
        "Job IDEditable" :=false;
        "Requisition DateEditable" :=false;
        ShortlistedEditable :=false;
        PriorityEditable :=false;
        "Required PositionsEditable" :=false;
        end;
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;

        UpdateControls;
    end;
}


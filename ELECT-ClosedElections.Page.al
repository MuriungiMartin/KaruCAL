#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 60014 "ELECT-Closed Elections"
{
    ApplicationArea = Basic;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable60000;
    SourceTableView = where(Status=filter(Closed));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Election Code";"Election Code")
                {
                    ApplicationArea = Basic;
                }
                field("Election Date";"Election Date")
                {
                    ApplicationArea = Basic;
                }
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
                }
                field("Election Description";"Election Description")
                {
                    ApplicationArea = Basic;
                }
                field("Election Approach";"Election Approach")
                {
                    ApplicationArea = Basic;
                }
                field("Voting Method";"Voting Method")
                {
                    ApplicationArea = Basic;
                }
                field("Voter Choice";"Voter Choice")
                {
                    ApplicationArea = Basic;
                }
                field("Allow Abstain";"Allow Abstain")
                {
                    ApplicationArea = Basic;
                }
                field("Abstain Candidate";"Abstain Candidate")
                {
                    ApplicationArea = Basic;
                }
                field("Active Students only";"Active Students only")
                {
                    ApplicationArea = Basic;
                }
                field("Candidate Balance Based on";"Candidate Balance Based on")
                {
                    ApplicationArea = Basic;
                }
                field("Candicate Balance";"Candicate Balance")
                {
                    ApplicationArea = Basic;
                }
                field("Voter Balance Based on";"Voter Balance Based on")
                {
                    ApplicationArea = Basic;
                }
                field("Voter Balance";"Voter Balance")
                {
                    ApplicationArea = Basic;
                }
                field("Voter Registration Method";"Voter Registration Method")
                {
                    ApplicationArea = Basic;
                }
                field("Registered Voters";"Registered Voters")
                {
                    ApplicationArea = Basic;
                }
                field("Eligible Voters";"Eligible Voters")
                {
                    ApplicationArea = Basic;
                }
                field("Total Voted";"Total Voted")
                {
                    ApplicationArea = Basic;
                }
                field("Did not Vote";"Did not Vote")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            group(Reports)
            {
                Caption = 'Reports';
                Image = Intrastat;
                action(VoterRegister)
                {
                    ApplicationArea = Basic;
                    Caption = 'Voter Register';
                    Image = RegisteredDocs;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        ELECTPollingCenters.Reset;
                        ELECTPollingCenters.SetRange("Election Code",Rec."Election Code");
                        if ELECTPollingCenters.Find('-') then begin
                          Report.Run(60009,true,false,ELECTPollingCenters);
                          end;
                    end;
                }
                action(Agents)
                {
                    ApplicationArea = Basic;
                    Caption = 'Agents';
                    Image = Aging;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        ELECTElectralDistricts.Reset;
                        ELECTElectralDistricts.SetRange("Election Code",Rec."Election Code");
                        if ELECTElectralDistricts.Find('-') then begin
                          Report.Run(60013,true,false,ELECTElectralDistricts);
                          end;
                    end;
                }
                action(BallotPapers)
                {
                    ApplicationArea = Basic;
                    Caption = 'Ballot Papers';
                    Image = Documents;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        ELECTPositions.Reset;
                        ELECTPositions.SetRange("Election Code",Rec."Election Code");
                        if ELECTPositions.Find('-') then Report.Run(60014,true,false);
                    end;
                }
                action(ResultsSummary)
                {
                    ApplicationArea = Basic;
                    Caption = 'Results Summary';
                    Image = SuggestGrid;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        ELECTPositions.Reset;
                        ELECTPositions.SetRange("Election Code",Rec."Election Code");
                        if ELECTPositions.Find('-') then Report.Run(60015,true,false);
                    end;
                }
                action(Winners)
                {
                    ApplicationArea = Basic;
                    Caption = 'Election Winners';
                    Image = AddToHome;
                    Promoted = true;
                    PromotedCategory = "Report";
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        ELECTPositions.Reset;
                        ELECTPositions.SetRange("Election Code",Rec."Election Code");
                        if ELECTPositions.Find('-') then Report.Run(60016,true,false);
                    end;
                }
            }
        }
    }

    var
        ELECTMyPositions: Record UnknownRecord60011;
        ELECTMyCandidates: Record UnknownRecord60012;
        ELECTVoterRegister: Record UnknownRecord60002;
        ELECTPositions: Record UnknownRecord60001;
        ELECTCandidates: Record UnknownRecord60006;
        Customer: Record Customer;
        ELECTElectralDistricts: Record UnknownRecord60004;
        ELECTPollingCenters: Record UnknownRecord60008;
        ELECTElectionsHeader: Record UnknownRecord60000;
        countedPosts: Integer;
        NoOfNominees: Integer;
        SuperiorNumbers: Integer;
        InferiorNumbers: Integer;
        SuperiorGender: Code[10];
        InferiorGender: Code[10];
        CountedMaleInTop: Integer;
        CountedFemaleInTop: Integer;
        SuperiorFound: Boolean;
        ELECTResults: Record UnknownRecord60010;
        ELECTResultsMales: Record UnknownRecord60010;
        ELECTResultsFemales: Record UnknownRecord60010;
}


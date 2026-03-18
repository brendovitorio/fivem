export interface OfficerData {
  passport: number;
  name: string;
  badge: string;
  rank: string;
  unit: string;
  joinDate: string;
  status: "10-8" | "10-7" | "Indisponível";
  isSuperior: boolean;
  stats: {
    arrests: number;
    tickets: number;
    reports: number;
    warrants: number;
  };
}

export interface PrisonRecord {
  id: number;
  police: string;
  services: number;
  fines: number;
  text: string;
  date: string;
}

export interface PortRecord {
  portId: number;
  portType: string;
  serial: string;
  date: string;
}

export interface CivilianSearchResult {
  found: boolean;
  passport: number;
  name: string;
  phone: string;
  fines: number;
  warrants: number;
  records: PrisonRecord[];
  ports: PortRecord[];
}

export interface Warrant {
  id: number;
  user_id: string;
  identity: string;
  status: string;
  nidentity: string;
  timeStamp: string;
  reason: string;
}

export interface Report {
  id: number;
  victim_id: string;
  police_name: string;
  solved: string | number | boolean;
  victim_name: string;
  created_at: string;
  victim_report: string;
  updated_at: string;
}

export interface InitialPayload {
  officer: OfficerData;
  reports: Report[];
  warrants: Warrant[];
}

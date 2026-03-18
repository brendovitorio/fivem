import { useCallback, useEffect, useMemo, useState } from "react";
import { nuiFetch, postNuiAction, isBrowserDev, type NuiMessage } from "../../lib/nui";
import type { CivilianSearchResult, InitialPayload, OfficerData, Report, Warrant } from "../types/mdt";

const mockOfficer: OfficerData = {
  passport: 1,
  name: "Oficial Revolt",
  badge: "0001",
  rank: "Officer",
  unit: "Police Department",
  joinDate: "01/01/2026",
  status: "10-8",
  isSuperior: true,
  stats: { arrests: 0, tickets: 0, reports: 0, warrants: 0 },
};

const mockPayload: InitialPayload = {
  officer: mockOfficer,
  reports: [],
  warrants: [],
};

const normalizeSolved = (value: Report["solved"]): boolean => {
  return value === true || value === 1 || value === "1" || value === "true";
};

export function useMdt() {
  const [visible, setVisible] = useState(isBrowserDev());
  const [loading, setLoading] = useState(true);
  const [officer, setOfficer] = useState<OfficerData>(mockOfficer);
  const [reports, setReports] = useState<Report[]>([]);
  const [warrants, setWarrants] = useState<Warrant[]>([]);
  const [searchResult, setSearchResult] = useState<CivilianSearchResult | null>(null);
  const [error, setError] = useState<string | null>(null);

  const refresh = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      if (isBrowserDev()) {
        setOfficer(mockPayload.officer);
        setReports(mockPayload.reports);
        setWarrants(mockPayload.warrants);
      } else {
        const payload = await nuiFetch<InitialPayload>("getInitialData");
        setOfficer(payload.officer);
        setReports(payload.reports ?? []);
        setWarrants(payload.warrants ?? []);
      }
    } catch (err) {
      setError(err instanceof Error ? err.message : "Falha ao carregar MDT.");
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    refresh();
  }, [refresh]);

  useEffect(() => {
    const handler = (event: MessageEvent<NuiMessage>) => {
      if (!event.data?.action) return;
      if (event.data.action === "openSystem") {
        setVisible(true);
        void refresh();
      }
      if (event.data.action === "closeSystem") {
        setVisible(false);
      }
      if (event.data.action === "updateData") {
        void refresh();
      }
    };

    window.addEventListener("message", handler);
    return () => window.removeEventListener("message", handler);
  }, [refresh]);

  useEffect(() => {
    const onKeyUp = (event: KeyboardEvent) => {
      if (event.key === "Escape" && visible) {
        void close();
      }
    };

    window.addEventListener("keyup", onKeyUp);
    return () => window.removeEventListener("keyup", onKeyUp);
  }, [visible]);

  const close = useCallback(async () => {
    if (isBrowserDev()) {
      setVisible(false);
      return;
    }
    await postNuiAction("closeSystem");
    setVisible(false);
  }, []);

  const searchCivilian = useCallback(async (passport: string | number) => {
    const numericPassport = Number(passport);
    if (!numericPassport || Number.isNaN(numericPassport)) {
      setSearchResult(null);
      return null;
    }

    try {
      const response = await nuiFetch<{ result: [boolean, string, string, number, any[], boolean, any[], number] }>("searchUser", {
        passaporte: numericPassport,
      });
      const result = response.result;
      if (!result?.[0]) {
        const notFound = {
          found: false,
          passport: numericPassport,
          name: "",
          phone: "",
          fines: 0,
          warrants: 0,
          records: [],
          ports: [],
        } satisfies CivilianSearchResult;
        setSearchResult(notFound);
        return notFound;
      }

      const mapped: CivilianSearchResult = {
        found: true,
        passport: numericPassport,
        name: result[1],
        phone: result[2],
        fines: Number(result[3] ?? 0),
        records: Array.isArray(result[4]) ? result[4] : [],
        warrants: Number(result[7] ?? 0),
        ports: Array.isArray(result[6]) ? result[6] : [],
      };
      setSearchResult(mapped);
      return mapped;
    } catch (err) {
      setError(err instanceof Error ? err.message : "Falha ao buscar cidadão.");
      return null;
    }
  }, []);

  const createReport = useCallback(async (payload: { victim_id: string; victim_name: string; victim_report: string }) => {
    await postNuiAction("addReport", payload);
    await refresh();
  }, [refresh]);

  const solveReport = useCallback(async (id: number) => {
    await postNuiAction("setReportSolved", { id });
    await refresh();
  }, [refresh]);

  const removeReport = useCallback(async (id: number) => {
    await postNuiAction("setReportRemoved", { id });
    await refresh();
  }, [refresh]);

  const createWarrant = useCallback(async (payload: { passaporte: number; nome: string; texto: string }) => {
    await postNuiAction("setWarrant", payload);
    await refresh();
  }, [refresh]);

  const removeWarrant = useCallback(async (id: number) => {
    await postNuiAction("deleteWarrant", { excluirpro: id });
    await refresh();
  }, [refresh]);

  const issueFine = useCallback(async (payload: { passaporte: number; multas: number; texto: string; cnh?: number }) => {
    await postNuiAction("initFine", {
      ...payload,
      cnh: payload.cnh ?? 0,
    });
    await refresh();
  }, [refresh]);

  const issuePrison = useCallback(async (payload: {
    passaporte: number;
    servicos: number;
    multas: number;
    texto: string;
    associacao?: string;
    material?: string;
    url?: string;
    militares?: string;
  }) => {
    await postNuiAction("initPrison", {
      associacao: payload.associacao ?? "Não informado",
      material: payload.material ?? "Não",
      url: payload.url ?? "",
      militares: payload.militares ?? "",
      ...payload,
    });
    await refresh();
  }, [refresh]);

  const stats = useMemo(() => ({
    totalReports: reports.length,
    solvedReports: reports.filter((item) => normalizeSolved(item.solved)).length,
    totalWarrants: warrants.length,
  }), [reports, warrants]);

  return {
    visible,
    loading,
    officer,
    reports,
    warrants,
    searchResult,
    error,
    stats,
    close,
    refresh,
    searchCivilian,
    createReport,
    solveReport,
    removeReport,
    createWarrant,
    removeWarrant,
    issueFine,
    issuePrison,
  };
}

export const reportSolved = normalizeSolved;

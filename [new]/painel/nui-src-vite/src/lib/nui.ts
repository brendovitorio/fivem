export const isBrowserDev = (): boolean => {
  return typeof window !== "undefined" && !("GetParentResourceName" in window);
};

export const getResourceName = (): string => {
  if (typeof window !== "undefined" && "GetParentResourceName" in window) {
    return (window as unknown as { GetParentResourceName: () => string }).GetParentResourceName();
  }
  return "police";
};

export async function nuiFetch<T>(eventName: string, data?: unknown): Promise<T> {
  if (isBrowserDev()) {
    throw new Error(`NUI callback '${eventName}' indisponível fora do FiveM.`);
  }

  const response = await fetch(`https://${getResourceName()}/${eventName}`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json; charset=UTF-8",
    },
    body: JSON.stringify(data ?? {}),
  });

  if (!response.ok) {
    throw new Error(`Falha ao chamar ${eventName}: ${response.status}`);
  }

  const text = await response.text();
  if (!text) return {} as T;

  try {
    return JSON.parse(text) as T;
  } catch {
    return text as T;
  }
}

export function postNuiAction(eventName: string, data?: unknown): Promise<void> {
  return nuiFetch(eventName, data).then(() => undefined);
}

export type NuiMessage<T = unknown> = {
  action: string;
  data?: T;
};

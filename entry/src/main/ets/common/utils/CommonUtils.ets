export function formatPrice(price: number): string {
  if (Number.isInteger(price)) {
    return `¥${price}`
  }
  return `¥${price.toFixed(1)}`
}

export function formatSales(sales: number): string {
  if (sales >= 10000) {
    return `${(sales / 10000).toFixed(1)}万人付款`
  }
  return `${sales}人付款`
}

export function formatLikes(count: number): string {
  if (count >= 10000) {
    return `${(count / 10000).toFixed(1)}w`
  }
  if (count >= 1000) {
    return `${(count / 1000).toFixed(1)}k`
  }
  return `${count}`
}

export function filterByKeyword(text: string, keyword: string): boolean {
  if (keyword.trim().length === 0) {
    return true
  }
  return text.toLowerCase().includes(keyword.trim().toLowerCase())
}

export function getUnreadTotal(unreads: number[]): number {
  return unreads.reduce((sum: number, n: number) => sum + n, 0)
}

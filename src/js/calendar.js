// Calendar page: render a year calendar from the post date index.

const WEEKDAY_LABELS = ["一", "二", "三", "四", "五", "六", "日"];
const MONTHS_PER_YEAR = 12;
const HASH_PATTERN = /^#(\d{4})(?:-(\d{2})-(\d{2}))?$/;

function pad2(value) {
  return value < 10 ? "0" + value : String(value);
}

function buildModel(posts) {
  var byDate = new Map();

  posts.forEach(function (post) {
    var sameDay = byDate.get(post.date);

    if (sameDay) {
      sameDay.push(post);
    } else {
      byDate.set(post.date, [post]);
    }
  });

  return { byDate: byDate };
}

function parseHash() {
  var match = window.location.hash.match(HASH_PATTERN);

  if (!match) {
    return null;
  }

  return {
    year: parseInt(match[1], 10),
    date:
      match[2] && match[3]
        ? match[1] + "-" + match[2] + "-" + match[3]
        : null,
  };
}

function formatDateLabel(dateStr) {
  var parts = dateStr.split("-");

  return (
    parseInt(parts[0], 10) +
    "年" +
    parseInt(parts[1], 10) +
    "月" +
    parseInt(parts[2], 10) +
    "日"
  );
}

function buildMonthIndex(byDate, year) {
  var months = [];
  var prefix = year + "-";

  for (var i = 0; i < MONTHS_PER_YEAR; i++) {
    months.push(new Map());
  }

  byDate.forEach(function (posts, date) {
    if (date.indexOf(prefix) !== 0) {
      return;
    }

    var monthIndex = parseInt(date.slice(5, 7), 10) - 1;
    months[monthIndex].set(date, posts);
  });

  return months;
}

function countPosts(dayMap) {
  var total = 0;

  dayMap.forEach(function (posts) {
    total += posts.length;
  });

  return total;
}

function renderMonthHead(month, postCount) {
  var head = document.createElement("div");
  head.className = "cal-month-head";

  var title = document.createElement("span");
  title.className = "cal-month-title";
  title.textContent = month + 1 + "月";

  var count = document.createElement("span");
  count.className = "cal-month-count";
  count.textContent = postCount > 0 ? postCount + " 篇" : "无文章";

  head.appendChild(title);
  head.appendChild(count);

  return head;
}

function renderWeekdays() {
  var row = document.createElement("div");
  row.className = "cal-weekdays";

  WEEKDAY_LABELS.forEach(function (label) {
    var cell = document.createElement("span");
    cell.className = "cal-weekday";
    cell.textContent = label;
    row.appendChild(cell);
  });

  return row;
}

function blankCell() {
  var cell = document.createElement("span");
  cell.className = "cal-day cal-day-blank";

  return cell;
}

function plainCell(day) {
  var cell = document.createElement("span");
  cell.className = "cal-day cal-day-plain";
  cell.textContent = day;

  return cell;
}

function createDayButton(day, dateStr, posts) {
  var button = document.createElement("button");
  button.type = "button";
  button.className = "cal-day cal-day-active";
  button.dataset.date = dateStr;
  button.textContent = day;
  button.setAttribute("aria-pressed", "false");
  button.setAttribute(
    "aria-label",
    formatDateLabel(dateStr) + "，" + posts.length + " 篇文章",
  );

  var titles = posts.map(function (post) {
    return post.title;
  });
  button.title = dateStr + "：" + titles.join("、");

  if (posts.length > 1) {
    var badge = document.createElement("span");
    badge.className = "cal-day-badge";
    badge.textContent = posts.length;
    button.appendChild(badge);
  }

  return button;
}

function renderDays(year, month, dayMap) {
  var container = document.createElement("div");
  container.className = "cal-days";

  var firstWeekday = (new Date(year, month, 1).getDay() + 6) % 7;
  var dayCount = new Date(year, month + 1, 0).getDate();
  var blank = 0;

  for (blank = 0; blank < firstWeekday; blank++) {
    container.appendChild(blankCell());
  }

  for (var day = 1; day <= dayCount; day++) {
    var dateStr = year + "-" + pad2(month + 1) + "-" + pad2(day);
    var posts = dayMap.get(dateStr);

    container.appendChild(
      posts ? createDayButton(day, dateStr, posts) : plainCell(day),
    );
  }

  return container;
}

function renderMonth(year, month, dayMap) {
  var postCount = countPosts(dayMap);
  var card = document.createElement("section");

  card.className = "cal-month" + (postCount > 0 ? "" : " cal-month-empty");
  card.dataset.month = String(month + 1);
  card.appendChild(renderMonthHead(month, postCount));

  if (postCount === 0) {
    return card;
  }

  card.appendChild(renderWeekdays());
  card.appendChild(renderDays(year, month, dayMap));

  var detail = document.createElement("div");
  detail.className = "cal-month-detail";
  detail.hidden = true;
  card.appendChild(detail);

  return card;
}

function renderYear(ctx, year) {
  var months = buildMonthIndex(ctx.state.model.byDate, year);
  var fragment = document.createDocumentFragment();

  for (var month = 0; month < MONTHS_PER_YEAR; month++) {
    fragment.appendChild(renderMonth(year, month, months[month]));
  }

  ctx.grid.textContent = "";
  ctx.grid.appendChild(fragment);
}

function fillDetail(detail, dateStr, posts) {
  var head = document.createElement("div");
  head.className = "cal-detail-head";

  var icon = document.createElement("i");
  icon.className = "fas fa-calendar-day";
  head.appendChild(icon);
  head.appendChild(
    document.createTextNode(
      " " + formatDateLabel(dateStr) + " · " + posts.length + " 篇",
    ),
  );

  var list = document.createElement("ul");
  list.className = "cal-detail-list";

  posts.forEach(function (post) {
    var item = document.createElement("li");
    var link = document.createElement("a");

    link.href = post.url;
    link.textContent = post.title;
    item.appendChild(link);
    list.appendChild(item);
  });

  detail.textContent = "";
  detail.appendChild(head);
  detail.appendChild(list);
}

function clearSelection(grid) {
  grid.querySelectorAll(".cal-day-active.is-selected").forEach(function (btn) {
    btn.classList.remove("is-selected");
    btn.setAttribute("aria-pressed", "false");
  });

  grid.querySelectorAll(".cal-month-detail").forEach(function (detail) {
    detail.hidden = true;
    detail.textContent = "";
  });
}

function findDetail(grid, dateStr) {
  var month = parseInt(dateStr.slice(5, 7), 10);
  var card = grid.querySelector('.cal-month[data-month="' + month + '"]');

  return card ? card.querySelector(".cal-month-detail") : null;
}

function selectDate(ctx, dateStr, scrollIntoView) {
  var button = ctx.grid.querySelector(
    '.cal-day-active[data-date="' + dateStr + '"]',
  );

  if (!button) {
    return;
  }

  clearSelection(ctx.grid);
  ctx.state.selectedDate = dateStr;

  button.classList.add("is-selected");
  button.setAttribute("aria-pressed", "true");

  var detail = findDetail(ctx.grid, dateStr);

  if (detail) {
    fillDetail(detail, dateStr, ctx.state.model.byDate.get(dateStr) || []);
    detail.hidden = false;
  }

  window.history.replaceState(null, "", "#" + dateStr);

  if (scrollIntoView) {
    var card = button.closest(".cal-month");

    if (card) {
      card.scrollIntoView({ block: "center" });
    }
  }
}

function updateStepButtons(ctx) {
  ctx.nav.querySelectorAll(".cal-year-step").forEach(function (step) {
    var delta = parseInt(step.dataset.step, 10);
    var nextYear = ctx.state.activeYear + delta;

    step.disabled =
      nextYear < ctx.bounds.first || nextYear > ctx.bounds.last;
  });
}

function activateYear(ctx, year, updateHash) {
  if (year < ctx.bounds.first || year > ctx.bounds.last) {
    return;
  }

  ctx.state.activeYear = year;
  ctx.state.selectedDate = null;

  ctx.yearButtons.forEach(function (button) {
    var isActive = parseInt(button.dataset.year, 10) === year;

    button.classList.toggle("is-active", isActive);
    button.setAttribute("aria-pressed", isActive ? "true" : "false");
  });

  renderYear(ctx, year);
  updateStepButtons(ctx);

  if (updateHash) {
    window.history.replaceState(null, "", "#" + year);
  }
}

function bindYearButtons(ctx, yearList) {
  yearList.addEventListener("click", function (event) {
    var button = event.target.closest(".cal-year-btn");

    if (!button) {
      return;
    }

    var year = parseInt(button.dataset.year, 10);

    if (year === ctx.state.activeYear) {
      return;
    }

    activateYear(ctx, year, true);
  });
}

function bindYearSteps(ctx) {
  ctx.nav.querySelectorAll(".cal-year-step").forEach(function (step) {
    step.addEventListener("click", function () {
      var delta = parseInt(step.dataset.step, 10);

      activateYear(ctx, ctx.state.activeYear + delta, true);
    });
  });
}

function bindDayClicks(ctx) {
  ctx.grid.addEventListener("click", function (event) {
    var button = event.target.closest(".cal-day-active");

    if (!button) {
      return;
    }

    selectDate(ctx, button.dataset.date, false);
  });
}

function renderMessage(grid, text) {
  var message = document.createElement("p");

  message.className = "calendar-message";
  message.textContent = text;

  grid.textContent = "";
  grid.appendChild(message);
}

function renderError(grid) {
  var message = document.createElement("p");
  var link = document.createElement("a");

  message.className = "calendar-message";
  message.appendChild(document.createTextNode("日历数据加载失败，可前往"));
  link.href = "/posts/";
  link.textContent = "全部文章";
  message.appendChild(link);
  message.appendChild(document.createTextNode("浏览。"));

  grid.textContent = "";
  grid.appendChild(message);
}

function initCalendar(grid, nav, yearList, yearButtons, bounds, model) {
  var ctx = {
    grid: grid,
    nav: nav,
    yearButtons: yearButtons,
    bounds: bounds,
    state: { model: model, activeYear: bounds.last, selectedDate: null },
  };

  bindYearButtons(ctx, yearList);
  bindYearSteps(ctx);
  bindDayClicks(ctx);

  var target = parseHash();
  var startYear = bounds.last;

  if (target && target.year >= bounds.first && target.year <= bounds.last) {
    startYear = target.year;
  }

  activateYear(ctx, startYear, false);

  if (target && target.date && model.byDate.has(target.date)) {
    selectDate(ctx, target.date, true);
  }
}

function setupCalendar() {
  var grid = document.getElementById("calendarGrid");

  if (!grid) {
    return;
  }

  var yearList = document.getElementById("calendarYearList");
  var nav = document.querySelector(".calendar-year-nav");

  if (!yearList || !nav) {
    renderMessage(grid, "暂无文章。");
    return;
  }

  var yearButtons = Array.prototype.slice.call(
    yearList.querySelectorAll(".cal-year-btn"),
  );
  var bounds = {
    first: parseInt(yearButtons[0].dataset.year, 10),
    last: parseInt(yearButtons[yearButtons.length - 1].dataset.year, 10),
  };

  fetch(grid.dataset.indexUrl)
    .then(function (response) {
      if (!response.ok) {
        throw new Error("calendar index HTTP " + response.status);
      }

      return response.json();
    })
    .then(function (posts) {
      initCalendar(grid, nav, yearList, yearButtons, bounds, buildModel(posts));
    })
    .catch(function () {
      renderError(grid);
    });
}

module.exports = { setupCalendar };

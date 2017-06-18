--小天照
local M = c999214
local Mid = 999214
function M.initial_effect(c)
	-- attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(M.val)
	c:RegisterEffect(e1)
	-- search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(Mid, 0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetTarget(M.thtg)
	e2:SetOperation(M.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end

function M.val(e, c)
	local atk = 0
	for i = 6, 7 do
		local tc = Duel.GetFieldCard(tp, LOCATION_SZONE, i)
		if tc and tc:IsSetCard(0xaa1) then
			atk = atk + math.floor(tc:GetBaseAttack()/2)
		end
	end
	return atk
end

function M.thfilter(c)
	return c:IsCode(999210) and c:IsAbleToHand()
end

function M.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end

function M.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp, M.thfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g, nil, REASON_EFFECT)
		Duel.ConfirmCards(1-tp, g)
	end
end
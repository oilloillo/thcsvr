--梦幻馆的浪漫者✿胡桃
function c14052.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--instant
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(14052,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(c14052.condition)
	e1:SetTarget(c14052.target)
	e1:SetOperation(c14052.operation)
	c:RegisterEffect(e1)
	--flip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(14052,1))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCost(c14052.cost)
	e2:SetTarget(c14052.tgtg)
	e2:SetOperation(c14052.tgop)
	c:RegisterEffect(e2)
	--to extra
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(14003,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCost(c14052.tec)
	e3:SetTarget(c14052.tetg)
	e3:SetOperation(c14052.teop)
	c:RegisterEffect(e3)
end
function c14052.condition(e,tp,eg,ep,ev,re,r,rp)
	local tn=Duel.GetTurnPlayer()
	local ph=Duel.GetCurrentPhase()
	return (tn==tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)) or (tn~=tp and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end
function c14052.filter(c,e,tp)
	return (c:IsSetCard(0x3208) or c:IsSetCard(0x138)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c14052.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c14052.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c14052.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c14052.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c14052.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c14052.tgfilter(c)
	return c:IsSetCard(0x138) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave() and (c:IsFaceup() or c:IsLocation(LOCATION_DECK))
end
function c14052.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c14052.tgfilter,tp,0x21,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,0x21)
end
function c14052.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c14052.tgfilter,tp,0x21,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c14052.tec(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,400) end
	Duel.PayLPCost(tp,400)
end
function c14052.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c14052.teop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoExtraP(e:GetHandler(),tp,REASON_EFFECT)
	end
end

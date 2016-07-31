 
--红魔✿永远鲜红的幼月
function c22057.initial_effect(c)
	--Race
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_ADD_RACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(RACE_FIEND)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22056,0))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCondition(c22057.damcon)
	e3:SetTarget(c22057.damtg)
	e3:SetOperation(c22057.damop)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22056,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_BATTLE_DESTROYED)
	e4:SetRange(LOCATION_HAND)
	e4:SetCondition(c22057.spcon)
	e4:SetTarget(c22057.sptg)
	e4:SetOperation(c22057.spop)
	c:RegisterEffect(e4)
	local e6=e4:Clone()
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCountLimit(1,22056+EFFECT_COUNT_CODE_DUEL)
	c:RegisterEffect(e6)
	--Scarlet Destiny
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_SZONE,0)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsCode,22105))
	c:RegisterEffect(e5)
end
function c22057.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE) and bc:IsReason(REASON_BATTLE)
end
function c22057.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1200)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1200)
end
function c22057.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c22057.spfilter(c,tp)
	return c:IsSetCard(0x813) and c:GetPreviousControler()==tp
end
function c22057.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22057.spfilter,1,nil,tp)
end
function c22057.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22057.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

 
--高雄型重巡洋舰-摩耶
function c50165.initial_effect(c)
	local temp = 0
	while temp<4 do
		c:RegisterFlagEffect(50200,0,0,0)
		temp = temp+1
	end
	--summon with no tribute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(50165,0))
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetCondition(c50165.ntcon)
	e2:SetOperation(c50165.ntop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(50165,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCost(c50165.descost)
	e3:SetTarget(c50165.destg)
	e3:SetOperation(c50165.desop)
	c:RegisterEffect(e3)
	--cannot special summon
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCode(EFFECT_SPSUMMON_CONDITION)
	e4:SetValue(aux.FALSE)
	c:RegisterEffect(e4)
end
function c50165.ntcon(e,c)
	if c==nil then return true end
	return c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.CheckLPCost(tp,700)
end
function c50165.ntop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.PayLPCost(tp,700)
end
function c50165.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c50165.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c50165.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and c50165.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c50165.desfilter,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c50165.desfilter,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c50165.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
